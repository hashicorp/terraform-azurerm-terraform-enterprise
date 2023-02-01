# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "fqdn" {
  value       = azurerm_public_ip.vm_bastion.fqdn
  description = "The FQDN of the bastion host vm"
}

output "private_ip" {
  value       = azurerm_linux_virtual_machine.vm_bastion.private_ip_address
  description = "The private IP address of the bastion virtual machine."
}
