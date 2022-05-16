output "login_url" {
  value       = module.standalone_airgap_dev.tfe_application_url
  description = "The URL to the TFE application"
}

output "ptfe_endpoint" {
  value       = module.standalone_airgap_dev.tfe_application_url
  description = "Terraform Enterprise Application URL"
}

output "ptfe_health_check" {
  value       = "${module.standalone_airgap_dev.tfe_application_url}/_health_check"
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

output "tfe_console_password" {
  value       = module.standalone_airgap_dev.tfe_console_password
  description = "The password for the TFE console"
}

output "tfe_console_url" {
  value       = "${module.standalone_airgap_dev.tfe_application_url}:8800"
  description = "Terraform Enterprise Console URL"
}