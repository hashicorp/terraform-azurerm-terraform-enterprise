output "login_url" {
  value       = module.standalone_airgap.tfe_application_url
  description = "The URL to the TFE application"
}

output "ptfe_endpoint" {
  value       = module.standalone_airgap.tfe_application_url
  description = "Terraform Enterprise Application URL"
}

output "ptfe_health_check" {
  value       = "${module.standalone_airgap.tfe_application_url}/_health_check"
  description = "Terraform Enterprise Health Check URL"
}

output "tfe_console_password" {
  value       = module.standalone_airgap.tfe_console_password
  description = "The password for the TFE console"
}

output "tfe_console_url" {
  value       = "${module.standalone_airgap.tfe_application_url}:8800"
  description = "Terraform Enterprise Console URL"
}