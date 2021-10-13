# General
# -------
output "resource_group_name" {
  value = local.resource_group_name
}

# Network
# -------
output "network_id" {
  value = module.network.network.id
}

output "network_redis_subnet_id" {
  value = module.network.redis_subnet.id
}

output "network_private_subnet_id" {
  value = module.network.private_subnet.id
}

output "network_frontend_subnet_id" {
  value = module.network.frontend_subnet.id
}

output "network_bastion_subnet_id" {
  value = module.network.bastion_subnet.id
}
