output "vmss" {
  value       = azurerm_linux_virtual_machine_scale_set.tfe_vmss
  description = "The Virtual Machine Scale Set on which TFE runs."
  sensitive   = true
}