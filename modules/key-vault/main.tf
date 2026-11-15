
resource "random_id" "key_vault_suffix" {
  byte_length = 4
}

resource "azurerm_key_vault" "main" {
  name = "kv-reprise-${var.environment}-${random_id.key_vault_suffix.hex}"

  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  public_network_access_enabled = false

  soft_delete_retention_days = 90
  purge_protection_enabled   = true

  network_acls {
    bypass         = "None"
    default_action = "Deny"
  }

  tags = var.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-keyvault-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-keyvault-${var.environment}"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "keyvault-dns-zone-group"
    private_dns_zone_ids = [var.key_vault_private_dns_zone_id]
  }

  tags = var.tags
}
