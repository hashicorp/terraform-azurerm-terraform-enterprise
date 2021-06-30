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

variable "proxy_cert_secret_name" {
  type        = string
  description = "Name of the secret under which the proxy cert is stored in the Azure Key Vault."
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

variable "redis_rdb_existing_storage_account" {
  default     = ""
  type        = string
  description = "(Optional) Name of an existing Premium Storage Account for data encryption at rest. If empty string is given, a new, Premium storage account will be created."
}

variable "redis_rdb_existing_storage_account_rg" {
  default     = ""
  type        = string
  description = "(Optional) Name of the resource group that contains the existing Premium Storage Account for data encryption at rest."
}

# Proxy
# -----
variable "proxy_cert_name" {
  default = "mitmproxy"
  type    = string
}

