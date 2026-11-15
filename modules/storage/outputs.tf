
output "storage_account_id" {
  description = "ID of the Azure Storage Account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account"
  value       = azurerm_storage_account.main.name
}

output "storage_private_endpoint_id" {
  description = "ID of the Storage private endpoint"
  value       = azurerm_private_endpoint.blob.id
}
