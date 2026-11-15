
output "resource_group_name" {
  description = "Name of the deployed resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Azure region hosting the infrastructure"
  value       = azurerm_resource_group.main.location
}

output "virtual_network_id" {
  description = "ID of the project virtual network"
  value       = module.networking.virtual_network_id
}

output "storage_account_name" {
  description = "Name of the private storage account"
  value       = module.storage.storage_account_name
}

output "key_vault_name" {
  description = "Name of the private Key Vault"
  value       = module.key_vault.key_vault_name
}

output "managed_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = module.managed_identity.managed_identity_id
}
