output "network_name" {
  value       = azurerm_virtual_network.tfe_network.name
  description = "The name of the virtual network used for all resources"
}

output "network_id" {
  value       = azurerm_virtual_network.tfe_network.id
  description = "The virtual network ID used for all resources"
}

output "network_private_subnet_id" {
  value       = azurerm_subnet.tfe_network_private_subnet.id
  description = "The subnet ID used for TFE"
}

output "network_frontend_subnet_id" {
  value       = azurerm_subnet.tfe_network_frontend_subnet.id
  description = "The subnet ID used for the front end"
}

output "network_bastion_subnet_id" {
  value       = var.create_bastion == true ? azurerm_subnet.tfe_network_bastion_subnet[0].id : ""
  description = "The subnet ID used for the Bastion"
}

output "network_redis_subnet_id" {
  value       = var.active_active == true ? azurerm_subnet.tfe_network_redis_subnet[0].id : ""
  description = "The subnet ID used for the Redis Cache"
}

output "database_subnet" {
  value = azurerm_subnet.database

  description = "The subnetwork dedicated to the database."
}

output "database_private_dns_zone" {
  value = azurerm_private_dns_zone.database

  description = "The private DNS zone dedicated to the database."
}
