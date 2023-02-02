variable "keyvault_name" {}
variable "keyvault_rg" {}
variable "secret_name" {}

data "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

data "azurerm_key_vault_secret" "secret" {
  name = var.secret_name
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

output "secret_value" {
  value = data.azurerm_key_vault_secret.secret.value
}
