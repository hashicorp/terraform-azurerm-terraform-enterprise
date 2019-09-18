resource "azurerm_network_interface" "primary" {
  count               = "${var.vm["count"]}"
  name                = "${local.prefix}-${count.index}"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "${local.ip_conf_name}"
    subnet_id                     = "${var.subnet_id}"
    public_ip_address_id          = "${element(azurerm_public_ip.primary.*.id, count.index)}"
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {
    "Name" = "${local.prefix}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "ptfe_api" {
  count                   = "${var.vm["count"]}"
  network_interface_id    = "${element(azurerm_network_interface.primary.*.id, count.index)}"
  ip_configuration_name   = "${local.ip_conf_name}"
  backend_address_pool_id = "${var.cluster_backend_pool_id}"
}
