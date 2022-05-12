locals {
  friendly_name_prefix      = random_string.friendly_name.id
  resource_group_name       = module.active_active.resource_group_name
  proxy_user                = "proxyuser"
  proxy_port                = "3128"
  network_proxy_subnet_cidr = "10.0.80.0/20"
}