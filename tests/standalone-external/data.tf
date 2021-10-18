data "azurerm_key_vault_certificate" "load_balancer" {
  name         = "wildcard"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_certificate" {
  name         = "wildcard-chained-certificate-pem"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "vm_key" {
  name         = "wildcard-private-key-pem"
  key_vault_id = var.key_vault_id
}
