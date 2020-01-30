output "primary_cloud_init_list" {
  value       = data.template_cloudinit_config.config.*.rendered
  description = "List of rendered cloud-init templates to pass to primary instances."
}

output "secondary_cloud_init" {
  value       = data.template_cloudinit_config.config_secondary.rendered
  description = "Rendered cloud-init template to pass to secondary scaling-set."
}

output "console_password" {
  value       = random_pet.console_password.id
  description = "The generated password for the admin console."
}

