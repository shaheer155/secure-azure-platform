
output "blob_private_dns_zone_id" {
  description = "Private DNS zone ID for Azure Blob Storage"
  value       = azurerm_private_dns_zone.blob.id
}

output "key_vault_private_dns_zone_id" {
  description = "Private DNS zone ID for Azure Key Vault"
  value       = azurerm_private_dns_zone.key_vault.id
}
