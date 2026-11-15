
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

module "private_dns" {
  source = "./modules/private-dns"

  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  virtual_network_id  = module.networking.virtual_network_id
  tags                = var.tags
}

module "storage" {
  source = "./modules/storage"

  project_name               = var.project_name
  environment                = var.environment
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  private_endpoint_subnet_id = module.networking.private_endpoint_subnet_id
  blob_private_dns_zone_id   = module.private_dns.blob_private_dns_zone_id
  tags                       = var.tags
}

module "key_vault" {
  source = "./modules/key-vault"

  project_name                  = var.project_name
  environment                   = var.environment
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  private_endpoint_subnet_id    = module.networking.private_endpoint_subnet_id
  key_vault_private_dns_zone_id = module.private_dns.key_vault_private_dns_zone_id
  tags                          = var.tags
}

module "managed_identity" {
  source = "./modules/managed-identity"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  storage_account_id  = module.storage.storage_account_id
  tags                = var.tags
}
