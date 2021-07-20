output "database_server_id" {
  value       = azurerm_postgresql_server.tfe_pg.id
  description = "The resource ID of the TFE PostgreSQL server"
}

output "database_server_name" {
  value       = azurerm_postgresql_server.tfe_pg.name
  description = "The name of the TFE PostgreSQL server"
}

output "database_server_fqdn" {
  value       = azurerm_postgresql_server.tfe_pg.fqdn
  description = "The fully qualified domain name of the TFE PostgreSQL database"
}

output "database_user" {
  value       = var.database_user
  description = "The username for the TFE PostgreSQL database"
}

output "database_password" {
  value       = random_string.tfe_pg_password.result
  description = "The password to the TFE PostgreSQL database"
}

output "database_id" {
  value       = azurerm_postgresql_database.tfe_pg_db.id
  description = "The resource ID of the TFE PostgreSQL database"
}

output "database_name" {
  value       = azurerm_postgresql_database.tfe_pg_db.name
  description = "The name of the TFE PostgreSQL database"
}
