
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
  description = "Resource group containing networking resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources"
  type        = map(string)
  default     = {}
}
