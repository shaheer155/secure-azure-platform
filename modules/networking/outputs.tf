
output "virtual_network_id" {
  description = "ID of the Azure virtual network"
  value       = azurerm_virtual_network.main.id
}

output "workload_subnet_id" {
  description = "ID of the workload subnet"
  value       = azurerm_subnet.workload.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoints.id
}
