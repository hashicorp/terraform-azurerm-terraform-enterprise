data "azurerm_dns_zone" "selected" {
  name                = "${var.dns["domain"]}"
  resource_group_name = "${var.dns["rg_name"]}"
}

resource "azurerm_dns_a_record" "api" {
  name                = "${local.prefix}-api"
  zone_name           = "${data.azurerm_dns_zone.selected.name}"
  resource_group_name = "${var.dns["rg_name"]}"
  ttl                 = "${var.dns["ttl"]}"
  records             = ["${azurerm_public_ip.azlb.ip_address}"]
  tags                = "${local.tags}"
}

resource "azurerm_dns_a_record" "application" {
  name                = "${local.prefix}"
  zone_name           = "${data.azurerm_dns_zone.selected.name}"
  resource_group_name = "${var.dns["rg_name"]}"
  ttl                 = "${var.dns["ttl"]}"
  records             = ["${azurerm_public_ip.azlb.ip_address}"]
  tags                = "${local.tags}"
}
