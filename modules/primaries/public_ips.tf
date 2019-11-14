# Static means it's gonna get allocated before getting attached.

resource "azurerm_public_ip" "primary" {
  count               = var.vm["count"]
  name                = "${local.prefix}-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = local.prefix
  }
}

