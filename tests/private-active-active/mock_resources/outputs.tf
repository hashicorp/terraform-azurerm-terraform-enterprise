output "friendly_name_prefix" {
  value = local.friendly_name_prefix
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "location" {
  value = azurerm_resource_group.main.location
}

output "host_id" {
  value = azurerm_linux_virtual_machine.proxy.id
}

output "host_private_ip" {
  value = azurerm_linux_virtual_machine.proxy.private_ip_address
}

output "network_id" {
  value = module.network.network_id
}

output "network_redis_subnet_id" {
  value = module.network.network_redis_subnet_id
}

output "network_private_subnet_id" {
  value = module.network.network_private_subnet_id
}

output "network_frontend_subnet_id" {
  value = module.network.network_frontend_subnet_id
}

output "proxy_port" {
  value = local.proxy_port
}

# bastion fqdn
output "bastion_fqdn" {
  value = azurerm_public_ip.vm_bastion.fqdn
}
