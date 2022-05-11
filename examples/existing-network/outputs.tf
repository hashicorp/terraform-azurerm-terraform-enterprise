output "active_active" {
  value       = module.active_active
  description = "The outputs of the active_active module"

  # This output is marked as sensitive to work around a bug in Terraform 0.14
  sensitive = true
}

output "login_url" {
  value       = module.active_active.tfe_application_url
  description = "The URL to the TFE application"
}

output "health_check_url" {
  value       = "${module.active_active.tfe_application_url}/_health_check"
  description = "The URL with path to access the TFE instance health check"
}

output "iact_url" {
  value       = "${module.active_active.tfe_application_url}/admin/retrieve-iact"
  description = "The URL with path to access the TFE instance Retrieve IACT"
}

output "initial_admin_user_url" {
  value       = "${module.active_active.tfe_application_url}/admin/initial-admin-user"
  description = "The URL with path to access the TFE instance Initial Admin User"
}