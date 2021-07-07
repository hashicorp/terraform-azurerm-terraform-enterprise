# General
# -------
variable "location" {
  default     = "East US"
  type        = string
  description = "(Required) Azure location name e.g. East US"
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
  description = "The resource group of the Azure Key Vault containing all required secrets and certificates."
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates."
}

variable "certificate_name" {
  type        = string
  description = "Azure Key Vault Certificate name for TLS certififate for DNS zone for Application Gateway or Load Balancer."
}

variable "ca_pem_key_secret_name" {
  type        = string
  description = "Name of the secret under which the DNS wildcard key is stored in the Azure Key Vault."
}

variable "ca_pem_certificate_secret_name" {
  type        = string
  description = "Name of the secret under which the DNS wildcard chained cert is stored in the Azure Key Vault."
}

# Storage
# -------
variable "resource_group_name_bootstrap" {
  type        = string
  description = "The resource group of the storage account that houses the TFE license"
}

variable "bootstrap_storage_account_name" {
  type        = string
  description = "The name of the storage account that houses the TFE license"
}

variable "bootstrap_storage_account_container_name" {
  type        = string
  description = "The name of the container that houses the TFE license"
}

# Proxy & Bastion
# ---------------
variable "proxy_cert_name" {
  default = "mitmproxy"
  type    = string
}

variable "proxy_key_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert key is stored in the Azure Key Vault."
}

variable "proxy_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert is stored in the Azure Key Vault."
}

variable "proxy_public_key_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy public key is stored in the Azure Key Vault."
}

variable "bastion_public_key_secret_name" {
  type        = string
  description = "Name of the secret under which the bastion public key is stored in the Azure Key Vault."
}
