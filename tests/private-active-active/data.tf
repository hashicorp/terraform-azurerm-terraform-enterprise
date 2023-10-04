# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "azurerm_key_vault_certificate" "load_balancer" {
  name         = var.load_balancer_certificate_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_certificate" {
  name         = var.vm_certificate_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_key" {
  name         = var.vm_key_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "tfe_license" {
  count = var.tfe_license_secret_name == null ? 0 : 1

  name         = var.tfe_license_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "bastion_public_ssh_key" {
  name         = var.bastion_public_ssh_key_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "proxy_public_ssh_key" {
  name         = var.proxy_public_ssh_key_secret_name
  key_vault_id = var.key_vault_id
}
