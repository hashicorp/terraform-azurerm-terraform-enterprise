output "network" {
  value       = azurerm_virtual_network.tfe_network
  description = "The virtual network used for all resources"
}

output "private_subnet" {
  value       = azurerm_subnet.tfe_network_private_subnet
  description = "The subnetwork used for TFE"
}

output "frontend_subnet" {
  value       = azurerm_subnet.tfe_network_frontend_subnet
  description = "The subnetwork used for the front end"
}

output "bastion_subnet" {
  value       = try(azurerm_subnet.tfe_network_bastion_subnet[0], null)
  description = "The subnetwork used for the Bastion"
}

output "redis_subnet" {
  value       = try(azurerm_subnet.tfe_network_redis_subnet[0], null)
  description = "The subnetwork used for the Redis Cache"
}

output "database_subnet" {
  value = try(azurerm_subnet.database[0], null)

  description = "The subnetwork dedicated to the database."
}

output "database_private_dns_zone" {
  value = try(azurerm_private_dns_zone.database[0], null)

  description = "The private DNS zone dedicated to the database."
}
