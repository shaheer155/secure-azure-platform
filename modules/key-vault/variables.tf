
variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "location" {
  description = "Azure deployment region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing Key Vault"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for Key Vault private endpoint"
  type        = string
}

variable "key_vault_private_dns_zone_id" {
  description = "Private DNS zone ID for Key Vault"
  type        = string
}

variable "tags" {
  description = "Tags applied to Key Vault resources"
  type        = map(string)
  default     = {}
}
