
variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "reprise-secure-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "location" {
  description = "Azure deployment region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "tags" {
  description = "Standard resource tags"
  type        = map(string)

  default = {
    project    = "reprise-secure-platform"
    managed_by = "Terraform"
    assessment = "cloud-engineer"
  }
}
