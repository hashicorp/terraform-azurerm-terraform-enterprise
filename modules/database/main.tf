resource "random_string" "tfe_pg_password" {
  length  = 24
  special = true
}

resource "azurerm_postgresql_flexible_server" "tfe_pg" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-pg"
  resource_group_name = var.resource_group_name

  administrator_login    = var.database_user
  administrator_password = random_string.tfe_pg_password.result
  backup_retention_days  = var.database_backup_retention_days
  sku_name               = var.database_machine_type
  storage_mb             = var.database_size_mb
  tags                   = var.tags
  version                = var.database_version
}

resource "azurerm_postgresql_flexible_server_database" "tfe_pg_db" {
  name      = "${var.friendly_name_prefix}-pg-db"
  server_id = azurerm_postgresql_flexible_server.tfe_pg.id

  charset   = "UTF8"
  collation = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "tfe_pg_vnet_rule" {
  name                = "${var.friendly_name_prefix}-db-vnet-rule"
  resource_group_name = var.resource_group_name

  subnet_id   = var.database_subnet
  server_name = azurerm_postgresql_flexible_server.tfe_pg.name
}
