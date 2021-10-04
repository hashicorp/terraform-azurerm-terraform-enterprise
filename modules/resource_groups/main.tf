locals {
  # Azure Resource Groups
  # ---------------------
  # Determine Azure resource group names based on optional values
  #   by default a new resource group will be created and used
  #   additionally, the same resource group will be used for dns
  #   and kv if alternative resource group names are not supplied
  resource_group_name     = var.resource_group_name == null ? azurerm_resource_group.tfe_resource_group[0].name : var.resource_group_name
  resource_group_name_dns = var.resource_group_name_dns == null ? local.resource_group_name : var.resource_group_name_dns
}

resource "azurerm_resource_group" "tfe_resource_group" {
  count = var.resource_group_name == null ? 1 : 0

  name     = "${var.friendly_name_prefix}-rg"
  location = var.location

  tags = var.tags
}
