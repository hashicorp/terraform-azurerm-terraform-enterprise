# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vmss" {
  value = azurerm_linux_virtual_machine_scale_set.tfe_vmss
}