
project_name        = "reprise-secure-platform"
environment         = "prod"
location            = "East US"
resource_group_name = "rg-reprise-secure-prod"

tags = {
  project     = "reprise-secure-platform"
  environment = "prod"
  managed_by  = "Terraform"
  assessment  = "cloud-engineer"
  cost_center = "production"
}
