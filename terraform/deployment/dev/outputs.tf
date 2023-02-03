output "keyvault_id" {
  value = module.keyvault.keyvault_id
}

output "postgres_fqdn" {
  value = module.postgres.server_fqdn
}

output "postgres_id" {
  value = module.postgres.server_id
}

output "postgres_database_id" {
  value = module.postgres.database_id
}

