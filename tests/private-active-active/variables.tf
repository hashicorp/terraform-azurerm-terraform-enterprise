# General
# -------
variable "location" {
  default     = "East US"
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
  description = "Name of resource group which contains desired key vault"
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing required certificate"
}

variable "ca_certificate_name" {
  type        = string
  description = "Azure Key Vault Certificate name for Application Gateway"
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the base64 encoded TFE license is stored in the Azure Key Vault"
}

# Proxy & Bastion
# ---------------
variable "proxy_public_key_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy public key is stored in the Azure Key Vault"
}

variable "bastion_public_key_secret_name" {
  type        = string
  description = "Name of the secret under which the bastion public key is stored in the Azure Key Vault"
}

variable "network_allow_range" {
  type        = string
  description = "Network range to allow access to bastion vm"
}

# User Data
# ---------
variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}
