variable "keyvault_name" {}
variable "keyvault_rg" {}
variable "secret_name" {}
variable "secret_value" {}
variable "environment" {}

data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

resource "azurerm_key_vault_secret" "secret" {
  name = var.secret_name
  value = var.secret_value
  key_vault_id = data.azurerm_key_vault.keyvault.id

  tags = {
    Creator = "terraform"
    Environment = var.environment
  }
}

output "secret_id" {
  value = azurerm_key_vault_secret.secret.id
}