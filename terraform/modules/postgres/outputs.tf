output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}

output "database_id" {
  value = [azurerm_postgresql_flexible_server_database.main.*.id]
}
