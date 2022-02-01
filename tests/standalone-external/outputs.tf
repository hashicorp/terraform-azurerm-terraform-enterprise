output "replicated_console_password" {
  value       = module.standalone_external.tfe_console_password
  description = "The password for the TFE console"
}

output "replicated_console_url" {
  value       = "${module.standalone_external.tfe_application_url}:8800"
  description = "Terraform Enterprise Console URL"
}

output "ptfe_endpoint" {
  value       = module.standalone_external.tfe_application_url
  description = "Terraform Enterprise Application URL"
}

output "ptfe_health_check" {
  value       = "${module.standalone_external.tfe_application_url}/_health_check"
  description = "Terraform Enterprise Health Check URL"
}

output "ssh_config_file" {
  value = local_file.ssh_config.filename

  description = "The pathname of the SSH configuration file that grants access to the compute instance."
}

output "ssh_private_key" {
  value = local_file.private_key_pem.filename

  description = "The pathname of the private SSH key."
}

output "vmss" {
  value       = module.standalone_external.vmss
  description = "The Virtual Machine Scale Set on which TFE runs."
  sensitive   = true
}