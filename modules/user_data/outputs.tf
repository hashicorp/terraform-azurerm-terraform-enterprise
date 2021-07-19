output "tfe_userdata_base64_encoded" {
  value       = base64encode(local.tfe_user_data)
  description = "The Base64 encoded User Data script built from modules/user_data/templates/tfe.sh.tpl"
}

output "tfe_console_password" {
  value       = random_string.password.result
  description = "The password for the TFE console"
}

output "user_token" {
  value       = local.base_configs.user_token
  description = "User token for TFE"
}
