
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
  description = "Resource group for the storage account"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the storage private endpoint"
  type        = string
}

variable "blob_private_dns_zone_id" {
  description = "Private DNS zone ID for Blob Storage"
  type        = string
}

variable "tags" {
  description = "Tags applied to storage resources"
  type        = map(string)
  default     = {}
}
