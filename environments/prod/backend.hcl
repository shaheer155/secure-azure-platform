resource_group_name  = "rg-reprise-terraform-state"
storage_account_name = "strepstate04b487b6"
container_name       = "tfstate"
key                  = "prod.terraform.tfstate"

use_azuread_auth = true
use_cli           = true