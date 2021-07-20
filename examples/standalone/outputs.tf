# Application
# -----------
output "tfe_application_url" {
  value       = module.tfe.tfe_application_url
  description = "Terraform Enterprise Application URL"
}

output "login_url" {
  value       = module.tfe.login_url
  description = "Login URL to setup the TFE instance once it is initialized"
}

output "tfe_console_url" {
  value       = module.tfe.tfe_console_url
  description = "Terraform Enterprise Console URL"
}

output "tfe_console_password" {
  value       = module.tfe.tfe_console_password
  description = "The password for the TFE console"
}

# SSH
# ---
output "instance_user_name" {
  value       = module.tfe.instance_user_name
  description = "The admin user on the TFE instance(s)"
}

output "instance_private_key" {
  value       = module.tfe.instance_private_key
  description = "The SSH private key to the TFE instance(s)"
}
