terraform {
  backend "azurerm" {
    resource_group_name  = "infra-shared"
    storage_account_name = "koyecloud001"
    container_name       = "terraform-state"
    key                  = "aks/dev.tfstate"
  }
}