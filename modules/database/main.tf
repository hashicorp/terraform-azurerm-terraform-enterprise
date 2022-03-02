resource "random_string" "tfe_pg_password" {
  length  = 24
  special = true
}

resource "azurerm_postgresql_flexible_server" "tfe" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-pg"
  resource_group_name = var.resource_group_name

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

resource "azurerm_postgresql_flexible_server_database" "tfe" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.tfe.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
