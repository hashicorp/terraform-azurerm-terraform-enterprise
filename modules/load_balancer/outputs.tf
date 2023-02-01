# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "load_balancer_backend_id" {
  value       = var.load_balancer_type == "application_gateway" ? [for pool in azurerm_application_gateway.tfe_ag[0].backend_address_pool : pool.id if pool.name == local.backend_address_pool_name][0] : azurerm_lb_backend_address_pool.tfe_load_balancer_be[0].id
  description = "The backend address pool ID"
}

output "load_balancer_ip" {
  value       = local.load_balancer_ip
  description = "The IP address of the load balancer"
}

output "fqdn" {
  value       = local.fqdn
  description = "Fully qualified domain name of the load balancer"
}

output "tfe_subdomain" {
  value       = local.tfe_subdomain
  description = "Subdomain for TFE"
}

