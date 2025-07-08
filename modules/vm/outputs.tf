# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vmss_name" {
  value       = azurerm_linux_virtual_machine_scale_set.tfe_vmss.name
  description = "The name of the virtual machine scale set"
}

output "vmss_instance_ids" {
  value       = toset([for i in data.azurerm_virtual_machine_scale_set.tfe_vmss.instances[*] : i.instance_id])
  description = "A list of the virual machine scale set VMs ids"
}

output "user_assigned_identity" {
  value = {
    name         = azurerm_user_assigned_identity.vmss.name
    client_id    = azurerm_user_assigned_identity.vmss.client_id
    tenant_id    = azurerm_user_assigned_identity.vmss.tenant_id
    principal_id = azurerm_user_assigned_identity.vmss.principal_id
  }
  description = "The user assigned identity created for the VMSS"
}
