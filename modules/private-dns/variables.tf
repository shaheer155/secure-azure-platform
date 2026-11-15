
variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing private DNS zones"
  type        = string
}

variable "location" {
  description = "Azure deployment region"
  type        = string
}

variable "virtual_network_id" {
  description = "Virtual network ID for private DNS links"
  type        = string
}

variable "tags" {
  description = "Tags applied to DNS resources"
  type        = map(string)
  default     = {}
}
