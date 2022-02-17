data "azurerm_key_vault_secret" "vm_certificate" {
  name         = var.vm_certificate_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_key" {
  name         = var.vm_key_secret_name
  key_vault_id = var.key_vault_id
}
