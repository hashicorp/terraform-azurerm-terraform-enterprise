# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "address" {
  value = "${azurerm_postgresql_flexible_server.tfe.fqdn}:5432"

  description = "The address of the PostgreSQL database."
}

output "name" {
  # This is the name of the default database created with the server. We must use the default database
  # until this issue is addressed: https://github.com/hashicorp/terraform-provider-azurerm/issues/15728
  value = "postgres"

  description = "The name of the PostgreSQL database."
}

output "server" {
  value = azurerm_postgresql_flexible_server.tfe

  description = "The PostgreSQL server."
}
