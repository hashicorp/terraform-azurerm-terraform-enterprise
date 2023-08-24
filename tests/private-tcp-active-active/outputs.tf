# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "private_tcp_active_active" {
  value       = module.private_tcp_active_active
  description = "The outputs of the private_tcp_active_active module"

  # This output is marked as sensitive to work around a bug in Terraform 0.14
  sensitive = true
}

output "tfe_url" {
  value       = module.private_tcp_active_active.tfe_application_url
  description = "The URL to the TFE application"
}

output "health_check_url" {
  value       = "${module.private_tcp_active_active.tfe_application_url}/_health_check"
  description = "The URL with path to access the TFE instance health check"
}

output "iact_url" {
  value       = "${module.private_tcp_active_active.tfe_application_url}/admin/retrieve-iact"
  description = "The URL with path to access the TFE instance Retrieve IACT"
}

output "initial_admin_user_url" {
  value       = "${module.private_tcp_active_active.tfe_application_url}/admin/initial-admin-user"
  description = "The URL with path to access the TFE instance Initial Admin User"
}

output "bastion_tunneling_command" {
  value = "az network bastion tunnel --name ${module.private_tcp_active_active.bastion_name} --resource-group ${module.private_tcp_active_active.bastion_resource_group_name} --target-resource-id ${module.test_proxy.instance.id} --resource-port 3128 --port 5000"
}
