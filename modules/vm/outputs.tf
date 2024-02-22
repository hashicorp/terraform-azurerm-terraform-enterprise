# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.tfe_vmss.name
}

output "vmss_instance_ids" {
  value = data.azurerm_virtual_machine_scale_set.example.instances
}
