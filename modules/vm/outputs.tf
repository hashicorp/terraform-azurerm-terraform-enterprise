# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.tfe_vmss.name
  description = "The name of the virtual machine scale set"
}

output "vmss_instance_ids" {
  value = toset([for i in data.azurerm_virtual_machine_scale_set.tfe_vmss.instances[*] : i.instance_id ])
  description = "A list of the virual machine scale set VMs ids"
}
