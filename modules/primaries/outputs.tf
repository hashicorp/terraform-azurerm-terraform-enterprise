output "public_ips" {
  value       = "${azurerm_public_ip.primary.*.ip_address}"
  description = "List of public ips for the nodes."
}

output "ssh_config_path" {
  value       = "${local.ssh_config_path}"
  description = "Path to the generated ssh_config file"
}

output "network_interfaces" {
  value       = "${azurerm_network_interface.primary.*.id}"
  description = "List of ids of Azure Network Interface objects tied to the primary vms."
}

output "ip_conf_name" {
  value       = "${local.ip_conf_name}"
  description = "The name of the IP Configuration object for the Azure Network Interfaces for the primary vms."
}
