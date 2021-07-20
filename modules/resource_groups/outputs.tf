output "resource_group_name" {
  value       = local.resource_group_name
  description = "The name of the resource group into which to provision all resources"
}

output "resource_group_name_dns" {
  value       = local.resource_group_name_dns
  description = "The name of the resource group that houses the DNS zone"
}

output "resource_group_name_kv" {
  value       = local.resource_group_name_kv
  description = "The name of the resource group that houses the key vault"
}
