# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "instance" {
  value       = azurerm_linux_virtual_machine.proxy
  description = "The proxy virtual machine resource"
}