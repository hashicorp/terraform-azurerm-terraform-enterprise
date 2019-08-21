output "application_endpoint" {
  value       = "https://${module.cluster_lb.app_endpoint_dns}"
  description = "The URI for accessing the application."
}

output "application_health_check" {
  value       = "http://${module.cluster_lb.app_endpoint_dns}/_health_check"
  description = "The URI for the application health checks."
}

output "install_id" {
  value       = "${random_string.install_id.result}"
  description = "The string prefix for resources."
}

output "installer_dashboard_endpoint" {
  value       = "https://${module.cluster_lb.app_endpoint_dns}:8800"
  description = "The URI for accessing the backend console."
}

output "installer_dashboard_password" {
  value       = "${module.configs.console_password}"
  description = "Generated password to unlock the installer dashboard."
}

output "primary_public_ip" {
  value       = "${element(module.primaries.public_ips, 0)}"
  description = "The public IP address of the first primary node created."
}

output "ssh_config_file" {
  value       = "${module.primaries.ssh_config_path}"
  description = "Path to ssh_config file for command: `ssh -F $(terraform state show <terraform_parent_modules>.module.<module_name>.module.primaries.local_file.ssh_config | grep filename | awk '{print $3}') default`"
}

output "ssh_private_key" {
  value       = "${module.common.ssh_private_key_path}"
  description = "Path to the private key used for ssh authorization."
}
