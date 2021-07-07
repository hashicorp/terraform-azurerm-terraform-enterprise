# Existing Key Vault
# ------------------
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}

# SSH keys
# --------
data "azurerm_key_vault_secret" "proxy_public_key" {
  name         = var.proxy_public_key_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "bastion_public_key" {
  name         = var.bastion_public_key_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}