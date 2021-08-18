# Azure Key Vault
# ---------------
data "azurerm_key_vault" "existing" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

resource "azurerm_key_vault_access_policy" "tfe_kv_acl" {
  key_vault_id = data.azurerm_key_vault.existing.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  certificate_permissions = var.certificate_permissions
  secret_permissions      = var.secret_permissions
}

data "azurerm_key_vault_certificate" "cert" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.existing.id
}

# If the TFE license filepath is supplied, then
# store the base64 encoded license in the Key Vault
# -------------------------------------------------
resource "azurerm_key_vault_secret" "tfe_license" {
  count = var.tfe_license_filepath == null ? 0 : 1

  name         = var.tfe_license_secret_name
  value        = filebase64(var.tfe_license_filepath)
  key_vault_id = data.azurerm_key_vault.existing.id

  depends_on = [azurerm_key_vault_access_policy.tfe_kv_acl]
}