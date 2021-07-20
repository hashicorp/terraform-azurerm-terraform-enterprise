output "bastion_host_id" {
  value       = azurerm_bastion_host.bastion_host.id
  description = "The resource ID of the Azure bastion host"

}

output "bastion_host_dns_name" {
  value       = azurerm_bastion_host.bastion_host.dns_name
  description = "The DNS name of the bastion host vm"
}
