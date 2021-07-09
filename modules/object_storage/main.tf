locals {
  storage_account_container_name = var.storage_account_container_name == null ? azurerm_storage_container.storage_account_container[0].name : var.storage_account_container_name
}

resource "azurerm_storage_container" "storage_account_container" {
  count = var.storage_account_container_name == null ? 1 : 0

  name                  = var.storage_account_name
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}
