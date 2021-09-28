# General
# -------
variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

# Domain
# ------
variable "domain_name" {
  type        = string
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

# Key Vault and Certificate
# -------------------------

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "vm_certificate_name" {
  type        = string
  description = "Azure Key Vault Certificate name for the Virtual Machine Scale Set"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

# Proxy & Bastion
# ---------------
variable "ca_certificate_name" {
  type        = string
  description = "Name of the secret under which the CA certificate for the mitmproxy is stored in the Azure Key Vault"
}

variable "proxy_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the proxy."
}

variable "bastion_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the bastion."
}

variable "network_allow_range" {
  default     = null
  type        = string
  description = "Network range to allow access to bastion vm"
}
