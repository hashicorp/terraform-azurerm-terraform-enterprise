output "replicated_console_password" {
  value       = module.standalone_poc.tfe_console_password
  description = "The password for the TFE console"
}

output "replicated_console_url" {
  value       = "${module.standalone_poc.tfe_application_url}:8800"
  description = "Terraform Enterprise Console URL"
}

output "ptfe_endpoint" {
  value       = module.standalone_poc.tfe_application_url
  description = "Terraform Enterprise Application URL"
}

output "ptfe_health_check" {
  value       = "${module.standalone_poc.tfe_application_url}/_health_check"
  description = "Terraform Enterprise Health Check URL"
}