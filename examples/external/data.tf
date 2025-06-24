
data "azurerm_key_vault_secret" "certificate" {
  name         = var.certificate_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "key" {
  name         = var.key_secret_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_certificate" "load_balancer_certificate" {
  name         = var.load_balancer_certificate
  key_vault_id = var.key_vault_id
}