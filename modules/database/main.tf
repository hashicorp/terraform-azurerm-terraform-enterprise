# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_string" "tfe_pg_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>?"
}

resource "azurerm_postgresql_flexible_server" "tfe" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-pg"
  resource_group_name = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  administrator_login    = var.database_user
  administrator_password = random_string.tfe_pg_password.result
  backup_retention_days  = var.database_backup_retention_days
  delegated_subnet_id    = var.database_subnet_id
  private_dns_zone_id    = var.database_private_dns_zone_id
  sku_name               = var.database_machine_type
  storage_mb             = var.database_size_mb
  tags                   = var.tags
  version                = var.database_version
  zone                   = var.database_availability_zone
}

resource "azurerm_postgresql_flexible_server_configuration" "tfe" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.tfe.id
  value     = join(",", var.database_extensions)
}
