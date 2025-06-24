# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "address" {
  value = "${azurerm_postgresql_flexible_server.tfe.fqdn}:5432"

  description = "The address of the PostgreSQL database."
}

output "name" {
  value = azurerm_postgresql_flexible_server_database.tfe.name

  description = "The name of the PostgreSQL database."
}

output "server" {
  value = azurerm_postgresql_flexible_server.tfe

  description = "The PostgreSQL server."
}
