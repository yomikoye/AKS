data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                            = "${var.environment}-keyvault-${var.keyvault_name}"
  location                        = var.rg_location
  resource_group_name             = var.rg_name
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = var.enable_rbac
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  sku_name = "standard"

  tags = {
    environment = var.environment
    creator  = "terraform"
  }
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers"
    ]

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Encrypt",
      "Decrypt",
      "WrapKey",
      "UnwrapKey",
      "Sign",
      "Verify",
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Encrypt",
      "Decrypt",
      "WrapKey",
      "UnwrapKey",
      "Sign",
      "Verify"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Update",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge",
      "RegenerateKey",
      "ListSAS",
      "SetSAS",
      "DeleteSAS"
    ]
  }
}