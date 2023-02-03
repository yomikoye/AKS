resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.server_name
  resource_group_name    = var.rg_name
  location               = var.location
  version                = var.server_version
  administrator_login    = var.admin_login
  administrator_password = var.admin_password
  zone                   = var.availability_zone
  backup_retention_days  = var.backup_retention_days
  storage_mb             = var.storage_size
  sku_name               = var.sku_name

  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }

  lifecycle {
    ignore_changes = [
      maintenance_window,
      zone,
    ]
  }

  tags = {
    creator     = "Terraform"
    environment = var.environment
  }
}

resource "azurerm_postgresql_flexible_server_configuration" "main" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = var.server_config
}

locals {
  pg_config = var.enable_pgbouncer == true ? {
    "pgbouncer.default_pool_size" : "100"
    "pgBouncer.max_client_conn" : "5000"
    "pgBouncer.pool_mode" : "TRANSACTION"
    "pgBouncer.min_pool_size" : "100"
    "pgbouncer.query_wait_timeout" : "120"
    "pgbouncer.server_idle_timeout" : "600"
    "pgbouncer.stats_users" : azurerm_postgresql_flexible_server.main.administrator_login
  } : {}
}

resource "azurerm_postgresql_flexible_server_configuration" "pgbouncer" {
  count     = var.enable_pgbouncer == true ? 1 : 0
  name      = "pgbouncer.enabled"
  value     = "true"
  server_id = azurerm_postgresql_flexible_server.main.id
}

resource "azurerm_postgresql_flexible_server_configuration" "pgbouncer_config" {
  for_each   = local.pg_config
  name       = each.key
  value      = each.value
  server_id  = azurerm_postgresql_flexible_server.main.id
  depends_on = [azurerm_postgresql_flexible_server_configuration.pgbouncer]
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  count     = length(var.database_names)
  name      = element(var.database_names, count.index)
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = var.database_collation
  charset   = var.database_charset
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAllAzureIps"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "main" {
  count            = length(var.allowed_cidrs)
  name             = "firewall-rule-${count.index}"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = cidrhost(element(var.allowed_cidrs, count.index), 0)
  end_ip_address   = cidrhost(element(var.allowed_cidrs, count.index), -1)
}

resource "azurerm_management_lock" "main" {
  count      = var.lock_enabled ? 1 : 0
  name       = "delete-lock"
  scope      = azurerm_postgresql_flexible_server.main.id
  lock_level = "CanNotDelete"
  notes      = "Prevent accidental deletion of the PostgreSQL server."
}