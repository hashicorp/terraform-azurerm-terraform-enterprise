# Certs
# -----
data "azurerm_key_vault_certificate" "wildcard" {
  name         = var.certificate_name
  key_vault_id = local.key_vault_id
}
