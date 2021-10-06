output "address" {
  value = "${azurerm_postgresql_flexible_server.tfe_pg.fqdn}:5432"

  description = "The address of the PostgreSQL database."
}
output "name" {
  # This is the name of the default database created with the server.
  value = "postgres"

  description = "The name of the PostgreSQL database."
}

output "server" {
  value = azurerm_postgresql_flexible_server.tfe_pg

  description = "The PostgreSQL server."
}
