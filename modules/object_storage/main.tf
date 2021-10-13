locals {
  storage_account_container_name                 = var.storage_account_container_name == null ? azurerm_storage_container.storage_account_container[0].name : var.storage_account_container_name
  storage_account_name                           = var.storage_account_name == null ? azurerm_storage_account.tfe_storage_account[0].name : var.storage_account_name
  storage_account_key                            = var.storage_account_key == null ? azurerm_storage_account.tfe_storage_account[0].primary_access_key : var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string == null ? azurerm_storage_account.tfe_storage_account[0].primary_blob_connection_string : var.storage_account_primary_blob_connection_string
}


# Storage Account
# ---------------
resource "random_pet" "random_pet_tfe_storage_account_name" {
  count = var.storage_account_name == null ? 1 : 0

  length = 3
  prefix = var.friendly_name_prefix
}

resource "azurerm_storage_account" "tfe_storage_account" {
  count = var.storage_account_name == null ? 1 : 0
  # Ensure the name is 24 alphanumeric characters as required by Azure.
  name = substr(
    lower(replace(random_pet.random_pet_tfe_storage_account_name[0].id, "/[^[:alnum:]]/", "")),
    0,
    24
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = var.tags
}

resource "azurerm_storage_container" "storage_account_container" {
  count = var.storage_account_container_name == null ? 1 : 0

  name                  = local.storage_account_name
  storage_account_name  = local.storage_account_name
  container_access_type = "private"
}
