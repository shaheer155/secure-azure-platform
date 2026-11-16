
data "azurerm_client_config" "current" {}

resource "random_id" "state_suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "state" {
  name     = "rg-reprise-terraform-state"
  location = "East US"

  tags = {
    project    = "reprise-secure-platform"
    purpose    = "terraform-remote-state"
    managed_by = "Terraform"
  }
}

resource "azurerm_storage_account" "state" {
  # Backend public access is temporarily required for the current
  # local Terraform client and GitHub-hosted runner.
  # checkov:skip=CKV_AZURE_59:Backend public access is temporarily required.
  # checkov:skip=CKV2_AZURE_33:Private endpoint deferred until runner connectivity is established.

  name                = "strepstate${random_id.state_suffix.hex}"
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location

  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 14
    }
  }

  tags = {
    project    = "reprise-secure-platform"
    purpose    = "terraform-remote-state"
    managed_by = "Terraform"
  }
}

resource "azurerm_storage_account_queue_properties" "state" {
  storage_account_id = azurerm_storage_account.state.id

  logging {
    delete                = true
    read                  = true
    write                 = true
    version               = "1.0"
    retention_policy_days = 7
  }
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"

  depends_on = [
    azurerm_role_assignment.state_blob_access
  ]
}

resource "azurerm_role_assignment" "state_blob_access" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
