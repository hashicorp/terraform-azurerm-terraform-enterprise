data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "tfe_redis_existing_storage_account" {
  count = var.redis.rdb_backup_enabled == true && var.redis.rdb_existing_storage_account != null ? 1 : 0

  name                = var.redis.rdb_existing_storage_account
  resource_group_name = var.redis.rdb_existing_storage_account_rg
}
