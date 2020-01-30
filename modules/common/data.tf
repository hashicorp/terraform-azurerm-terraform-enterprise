data "azurerm_resource_group" "selected" {
  name = var.rg_name
}

data "azurerm_virtual_network" "selected" {
  name                = var.vnet["name"]
  resource_group_name = local.rendered_vnet_rg_name
}

data "azurerm_subnet" "app_selected" {
  name                 = var.subnet_name
  resource_group_name  = local.rendered_vnet_rg_name
  virtual_network_name = var.vnet["name"]
}

data "azurerm_resource_group" "kv_selected" {
  name = local.rendered_kv_rg_name
}

data "azurerm_key_vault" "selected" {
  name                = var.key_vault["name"]
  resource_group_name = local.rendered_kv_rg_name
}

data "azurerm_key_vault_secret" "ptfe" {
  name         = azurerm_key_vault_certificate.ptfe.name
  key_vault_id = data.azurerm_key_vault.selected.id
  depends_on   = [azurerm_key_vault_certificate.ptfe]
}

