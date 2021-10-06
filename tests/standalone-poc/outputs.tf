output "replicated_console_password" {
  value = module.standalone_poc.tfe_console_password
}

output "replicated_console_url" {
  value = "${module.standalone_poc.tfe_application_url}:8800"
}

output "ptfe_endpoint" {
  value = module.standalone_poc.tfe_application_url
}

output "ptfe_health_check" {
  value = "${module.standalone_poc.tfe_application_url}/_health_check"
}