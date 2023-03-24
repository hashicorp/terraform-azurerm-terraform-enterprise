# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "azurerm_client_config" "current" {}

locals {
  key_vault_id = var.key_vault_id == null ? azurerm_key_vault.main[0].id : var.key_vault_id
}

# Create a Resource Group and Key Vault if one is not provided
# ------------------------------------------------------------
resource "azurerm_resource_group" "key_vault" {
  count = var.key_vault_id == null ? 1 : 0

  name     = "${var.key_vault_name}-rg"
  location = var.location
}

resource "azurerm_key_vault" "main" {
  count = var.key_vault_id == null ? 1 : 0

  name                        = var.key_vault_name
  location                    = azurerm_resource_group.key_vault[0].location
  resource_group_name         = azurerm_resource_group.key_vault[0].name
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
      "Release",
      "Rotate",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    certificate_permissions = [
      "Backup",
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "Recover",
      "Restore",
      "SetIssuers",
      "Update"
    ]

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]

    storage_permissions = [
      "Backup",
      "Delete",
      "DeleteSAS",
      "Get",
      "GetSAS",
      "List",
      "ListSAS",
      "Purge",
      "Recover",
      "RegenerateKey",
      "Restore",
      "Set",
      "SetSAS",
      "Update"
    ]
  }
}