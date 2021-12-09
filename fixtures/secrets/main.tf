# Store the Base64 Encoded TFE License as a Secret
# ------------------------------------------------
resource "azurerm_key_vault_secret" "tfe_license" {
  count = var.tfe_license == null ? 0 : 1

  name         = var.tfe_license.name
  value        = filebase64(var.tfe_license.path)
  key_vault_id = var.key_vault_id

  tags = var.tags
}

# Store cert's chained cert and key as Secrets
# --------------------------------------------
resource "azurerm_key_vault_secret" "private_key_pem" {
  count = var.private_key_pem == null ? 0 : 1

  name         = var.private_key_pem.name
  value        = base64encode(var.private_key_pem.value)
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "chained_certificate_pem" {
  count = var.chained_certificate_pem == null ? 0 : 1

  name         = var.chained_certificate_pem.name
  value        = base64encode(var.chained_certificate_pem.value)
  key_vault_id = var.key_vault_id

  tags = var.tags
}

# Store keys as secrets
# ---------------------
resource "azurerm_key_vault_secret" "proxy_public_key" {
  count = var.proxy_public_key == null ? 0 : 1

  name         = var.proxy_public_key.name
  value        = var.proxy_public_key.value
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "proxy_private_key" {
  count = var.proxy_private_key == null ? 0 : 1

  name         = var.proxy_private_key.name
  value        = var.proxy_private_key.value
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "bastion_public_key" {
  count = var.bastion_public_key == null ? 0 : 1

  name         = var.bastion_public_key.name
  value        = var.bastion_public_key.value
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "bastion_private_key" {
  count = var.bastion_private_key == null ? 0 : 1

  name         = var.bastion_private_key.name
  value        = var.bastion_private_key.value
  key_vault_id = var.key_vault_id

  tags = var.tags
}

# Store the CA certificate as secrets
# -----------------------------------
resource "azurerm_key_vault_secret" "ca_certificate" {
  count = var.ca_certificate == null ? 0 : 1

  name         = var.ca_certificate.name
  value        = base64encode(var.ca_certificate.value)
  key_vault_id = var.key_vault_id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "ca_private_key" {
  count = var.ca_private_key == null ? 0 : 1

  name         = var.ca_private_key.name
  value        = base64encode(var.ca_private_key.value)
  key_vault_id = var.key_vault_id

  tags = var.tags
}
