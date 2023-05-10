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

resource "random_password" "password" {
  count            = 2
  length           = 22
  special          = true
  override_special = "$#_%@"
}
resource "azurerm_key_vault_secret" "postgres" {
  name         = "${var.environment}-postgres-admin-password"
  value        = random_password.password[0].result
  key_vault_id = module.keyvault.keyvault_id

  tags = {
    Creator     = "Terraform"
    Environment = var.environment
  }
}

module "postgres" {
  source           = "../../modules/postgres"
  server_name      = var.server_name
  environment      = var.environment
  rg_name          = azurerm_resource_group.main.name
  location         = azurerm_resource_group.main.location
  admin_login      = var.admin_login
  admin_password   = azurerm_key_vault_secret.postgres.value
  allowed_cidrs    = var.allowed_cidrs
  sku_name         = var.postgres_sku_name
  enable_pgbouncer = var.enable_pgbouncer
}

module "acr" {
  source      = "../../modules/acr"
  environment = var.environment
  acr_name    = var.acr_name
  rg_name     = azurerm_resource_group.main.name
  location    = azurerm_resource_group.main.location
}

# module "aks" {
#   source         = "../../modules/aks"
#   aks_name       = "aks-${var.environment}-koyecloud"
#   environment    = var.environment
#   rg_name        = azurerm_resource_group.main.name
#   location       = azurerm_resource_group.main.location
#   admin_login    = var.admin_login
#   admin_password = azurerm_key_vault_secret.postgres.value
#   allowed_cidrs  = var.allowed_cidrs
# }

# resource "azurerm_role_assignment" "acr_aks" {
#   principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = module.acr.id
#   skip_service_principal_aad_check = true
# }