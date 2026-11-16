
resource "random_id" "storage_suffix" {
  byte_length = 4
}

resource "azurerm_storage_account" "main" {
  name = "streprise${var.environment}${random_id.storage_suffix.hex}"

  resource_group_name = var.resource_group_name
  location            = var.location

  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"

  min_tls_version                   = "TLS1_2"
  https_traffic_only_enabled        = true
  public_network_access_enabled     = false
  shared_access_key_enabled         = false
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true
  local_user_enabled                = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 14
    }

    container_delete_retention_policy {
      days = 14
    }
  }

  tags = var.tags
}

resource "azurerm_storage_account_queue_properties" "main" {
  storage_account_id = azurerm_storage_account.main.id

  logging {
    delete                = true
    read                  = true
    write                 = true
    version               = "1.0"
    retention_policy_days = 7
  }
}

resource "azurerm_private_endpoint" "blob" {
  name                = "pe-storage-blob-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-storage-blob-${var.environment}"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "storage-dns-zone-group"
    private_dns_zone_ids = [var.blob_private_dns_zone_id]
  }

  tags = var.tags
}
