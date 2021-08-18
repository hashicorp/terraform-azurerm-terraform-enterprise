# Certs
# -----
// data "azurerm_key_vault_secret" "user_data_cert" {
//   name         = var.ca_pem_key_secret_name
//   key_vault_id = local.key_vault_id
// }

data "azurerm_key_vault_secret" "user_data_cert_key" {
  name         = var.ca_pem_certificate_secret_name
  key_vault_id = local.key_vault_id
}
