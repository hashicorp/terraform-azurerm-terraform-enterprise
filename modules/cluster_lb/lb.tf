resource "azurerm_public_ip" "azlb" {
  name                = "${local.prefix}-publicIP"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = "${local.tags}"
}

resource "azurerm_lb" "azlb" {
  name                = "${local.prefix}-lb"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard"
  tags                = "${local.tags}"

  frontend_ip_configuration {
    name                          = local.frontend
    public_ip_address_id          = azurerm_public_ip.azlb.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "azlb" {
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.azlb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "azlb" {
  count               = length(var.lb_port)
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.azlb.id
  name                = element(keys(var.lb_port), count.index)
  protocol            = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  port                = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
}

resource "azurerm_lb_rule" "azlb" {
  count                          = length(var.lb_port)
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = element(keys(var.lb_port), count.index)
  protocol                       = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  backend_port                   = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  frontend_ip_configuration_name = local.frontend
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.azlb.id
  idle_timeout_in_minutes        = 5
  probe_id                       = element(azurerm_lb_probe.azlb.*.id, count.index)
  depends_on                     = [azurerm_lb_probe.azlb]
}

