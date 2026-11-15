
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
  description = "Resource group containing the managed identity"
  type        = string
}

variable "storage_account_id" {
  description = "Storage Account ID used as the RBAC scope"
  type        = string
}

variable "tags" {
  description = "Tags applied to the managed identity"
  type        = map(string)
  default     = {}
}
