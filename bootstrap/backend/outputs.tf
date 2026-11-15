
output "state_resource_group_name" {
  description = "Resource group hosting Terraform state"
  value       = azurerm_resource_group.state.name
}

output "state_storage_account_name" {
  description = "Storage account holding Terraform state"
  value       = azurerm_storage_account.state.name
}

output "state_container_name" {
  description = "Private container for Terraform state"
  value       = azurerm_storage_container.state.name
}

output "state_storage_account_id" {
  description = "Resource ID of the state storage account"
  value       = azurerm_storage_account.state.id
}
