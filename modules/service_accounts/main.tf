locals {
  storage_account_name                           = var.storage_account_name == null ? azurerm_storage_account.tfe_storage_account[0].name : var.storage_account_name
  storage_account_key                            = var.storage_account_key == null ? azurerm_storage_account.tfe_storage_account[0].primary_access_key : var.storage_account_key
  storage_account_primary_blob_connection_string = var.storage_account_primary_blob_connection_string == null ? azurerm_storage_account.tfe_storage_account[0].primary_blob_connection_string : var.storage_account_primary_blob_connection_string
  bootstrap_storage_account_name                 = var.bootstrap_storage_account_name == null ? azurerm_storage_account.bootstrap_storage_account[0].name : var.bootstrap_storage_account_name
}

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

  account_tier             = "Standard"
  account_replication_type = var.storage_account_replication_type

  tags = var.tags
}

resource "random_pet" "random_pet_bootstrap_storage_account_name" {
  count = var.bootstrap_storage_account_name == null ? 1 : 0

  length    = 3
  separator = ""
}

resource "azurerm_storage_account" "bootstrap_storage_account" {
  count = var.bootstrap_storage_account_name == null ? 1 : 0

  name                = substr(random_pet.random_pet_bootstrap_storage_account_name[0].id, 0, 24)
  location            = var.location
  resource_group_name = var.resource_group_name_bootstrap

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "vmss" {
  location            = var.location
  name                = "${var.friendly_name_prefix}-vmss"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_role_assignment" "tfe_vmss_role_assignment" {
  scope                = var.resource_group_id_bootstrap
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.vmss.principal_id
}

# Key Vault Policy - allow 'get' permission for vmss's managed identity
# ----------------
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
  count = var.key_vault_name == null ? 0 :1

  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

resource "azurerm_key_vault_access_policy" "tfe_vmss_kv_access" {
  count = var.key_vault_name == null ? 0 :1

  key_vault_id = data.azurerm_key_vault.kv[0].id
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