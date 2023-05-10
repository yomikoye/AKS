resource "azurerm_container_registry" "acr" {
  name                = "${var.environment}${var.acr_name}acr"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false
  tags = {
    "Creator"     = "Terraform"
    "Environment" = var.environment
  }
}