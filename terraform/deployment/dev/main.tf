resource "azurerm_resource_group" "main" {
  name     = var.rg_name
  location = var.location
}

module "keyvault" {
  source        = "../../modules/keyvault"
  keyvault_name = var.keyvault_name
  environment   = var.environment
  rg_location   = azurerm_resource_group.main.location
  rg_name       = azurerm_resource_group.main.name
  enable_rbac   = var.enable_rbac
}

resource "random_password" "postgres" {
  count            = 2
  length           = 22
  special          = true
  override_special = "$#_%@"
}
resource "azurerm_key_vault_secret" "postgres" {
  name         = "postgres-${var.environment}-admin-password"
  value        = random_password.postgres[0].result
  key_vault_id = module.keyvault.keyvault_id

  tags = {
    environment = var.environment
    creator     = "terraform"
  }
}

module "postgres" {
  source         = "../../modules/postgres"
  server_name    = "postgres-${var.environment}-koyecloud"
  environment    = var.environment
  rg_name        = azurerm_resource_group.main.name
  location       = azurerm_resource_group.main.location
  admin_login    = var.admin_login
  admin_password = azurerm_key_vault_secret.postgres.value
  allowed_cidrs = var.allowed_cidrs
}
  