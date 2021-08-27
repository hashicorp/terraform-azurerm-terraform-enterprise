locals {
  storage_account_name                           = var.storage_account_name == null ? azurerm_storage_account.tfe_storage_account[0].name : var.storage_account_name
  storage_account_key                            = var.storage_account_key == null ? azurerm_storage_account.tfe_storage_account[0].primary_access_key : var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string == null ? azurerm_storage_account.tfe_storage_account[0].primary_blob_connection_string : var.storage_account_primary_blob_connection_string
}


# Storage Account
# ---------------
resource "random_pet" "random_pet_tfe_storage_account_name" {
  count = var.storage_account_name == null ? 1 : 0

  length    = 3
  separator = ""
}

resource "azurerm_storage_account" "tfe_storage_account" {
  count = var.storage_account_name == null ? 1 : 0

  name                = substr(random_pet.random_pet_tfe_storage_account_name[0].id, 0, 24)
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = var.tags
}

# Key Vault Policy - allow 'get' permission for vmss's managed identity
# ----------------
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

resource "azurerm_user_assigned_identity" "vmss" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-vmss"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "tfe_vmss_kv_access" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.vmss.principal_id

  certificate_permissions = [
    "get",
    "list"
  ]

  secret_permissions = [
    "get",
    "list"
  ]
}

data "azurerm_key_vault_certificate" "certificate" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "trusted_root_certificate" {
  count = var.trusted_root_certificate_name == null ? 0 : 1

  name         = var.trusted_root_certificate_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
