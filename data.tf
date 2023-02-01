# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "azurerm_client_config" "current" {}

data "azurerm_storage_account" "tfe_redis_existing_storage_account" {
  count = var.redis_rdb_backup_enabled == true && var.redis_rdb_existing_storage_account != null ? 1 : 0

  name                = var.redis_rdb_existing_storage_account
  resource_group_name = var.redis_rdb_existing_storage_account_rg
}
