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
variable "resource_group_name_kv" {
  type        = string
  description = "The resource group of the Azure Key Vault containing all required secrets and certificates"
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates"
}

variable "ca_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the DNS wildcard key is stored in the Azure Key Vault"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

# Proxy & Bastion
# ---------------
variable "proxy_key_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert key is stored in the Azure Key Vault"
}

variable "proxy_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert is stored in the Azure Key Vault"
}

variable "proxy_public_key" {
  type        = string
  description = "The public SSH key for the proxy."
}

variable "bastion_public_key" {
  type        = string
  description = "The public SSH key for the bastion."
}

variable "network_allow_range" {
  type        = string
  description = "Network range to allow access to bastion vm"
}
