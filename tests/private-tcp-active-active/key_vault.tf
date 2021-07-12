# Certs
# -----
data "azurerm_key_vault_secret" "user_data_cert" {
  name         = var.ca_pem_key_secret_name
  key_vault_id = local.key_vault_id
}

data "azurerm_key_vault_secret" "user_data_cert_key" {
  name         = var.ca_pem_certificate_secret_name
  key_vault_id = local.key_vault_id
}

data "azurerm_key_vault_secret" "user_data_ca" {
  name         = var.proxy_cert_secret_name
  key_vault_id = local.key_vault_id
}

# SSH keys
# --------
data "azurerm_key_vault_secret" "proxy_public_key" {
  name         = var.proxy_public_key_secret_name
  key_vault_id = local.key_vault_id
}

data "azurerm_key_vault_secret" "bastion_public_key" {
  name         = var.bastion_public_key_secret_name
  key_vault_id = local.key_vault_id
}