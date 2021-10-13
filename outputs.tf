# Application
# -----------
output "tfe_application_url" {
  value       = "https://${module.load_balancer.fqdn}"
  description = "Terraform Enterprise Application URL"
}

output "login_url" {
  value       = "https://${module.load_balancer.fqdn}/admin/account/new?token=${module.user_data.user_token.value}"
  description = "Login URL to setup the TFE instance once it is initialized"
}

output "tfe_console_url" {
  value       = "https://${module.load_balancer.fqdn}:8800"
  description = "Terraform Enterprise Console URL"
}

# General
# -------
output "resource_group_name" {
  value       = module.resource_groups.resource_group_name
  description = "The name of the resource group into which to provision all resources"
}

# Network
# -------
output "network" {
  value       = local.network
  description = "The virtual network used for all resources"
}

# Service Accounts
# ----------------
output "storage_account_name" {
  value       = local.object_storage.storage_account_name
  description = "The name of the storage account used by TFE"
}

# Object Storage
# --------------
output "storage_account_container_name" {
  value       = local.object_storage.storage_account_container_name
  description = "The name of the container used by TFE"
}

# Database
# --------
output "database" {
  value       = local.database
  description = "The TFE PostgreSQL database."
}

# SSH
# ---
output "instance_private_key" {
  value       = var.vm_public_key == null ? tls_private_key.tfe_ssh[0].private_key_pem : "An existing 'vm_public_key' was provided"
  description = "The SSH private key to the TFE instance(s)"
}

# Bastion
# -------
output "bastion_host_id" {
  value       = var.create_bastion == true ? module.bastion.*.bastion_host_id : []
  description = "The resource ID of the Azure bastion host"
}

output "bastion_host_dns_name" {
  value       = var.create_bastion == true ? module.bastion.*.bastion_host_dns_name : []
  description = "The DNS name of the bastion host vm"
}

# User_data
# ---------
output "tfe_userdata_base64_encoded" {
  value       = module.user_data.tfe_userdata_base64_encoded
  description = "The Base64 encoded User Data script built from modules/user_data/templates/tfe.sh.tpl"
}

output "tfe_console_password" {
  value       = module.user_data.tfe_console_password
  description = "The password for the TFE console"
}

# Redis
# -----
output "redis_hostname" {
  value       = local.active_active == true ? module.redis[0].redis_hostname : null
  description = "The Hostname of the Redis Instance"
}

output "redis_ssl_port" {
  value       = local.active_active == true ? module.redis[0].redis_ssl_port : null
  description = "The SSL Port of the Redis Instance"
}

output "redis_pass" {
  value       = local.active_active == true ? module.redis[0].redis_pass : null
  description = "The Primary Access Key for the Redis Instance"
}

# Load balancer
# -------------
output "load_balancer_backend_id" {
  value       = module.load_balancer.load_balancer_backend_id
  description = "The backend address pool ID"
}

output "load_balancer_ip" {
  value       = var.dns_create_record == false ? "External DNS record must be configured for: ${module.load_balancer.load_balancer_ip}" : module.load_balancer.load_balancer_ip
  description = "The IP address of the load balancer"
}

# VM
# --
output "instance_user_name" {
  value       = var.vm_user
  description = "The admin user on the TFE instance(s)"
}
