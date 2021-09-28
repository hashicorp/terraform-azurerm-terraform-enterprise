data "azurerm_key_vault_certificate" "vm" {
  name         = var.vm_certificate_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_certificate" "ca" {
  name         = var.ca_certificate_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_certificate_data" "ca" {
  name         = var.ca_certificate_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "tfe_license" {
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
