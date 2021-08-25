# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "Name prefix used for resources"
}

# Provider
# --------
variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

# Storage Account
# ---------------
variable "storage_account_tier" {
  default     = "Standard"
  type        = string
  description = "Storage account tier Standard or Premium"
}

variable "storage_account_replication_type" {
  default     = "ZRS"
  type        = string
  description = "Storage account type LRS, GRS, RAGRS, ZRS"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "storage_account_key" {
  type        = string
  description = "Storage account key"
}

variable "storage_account_primary_blob_connection_string" {
  type        = string
  description = "Storage account primary blob endpoint"
}

# Key Vault
# ---------
variable "resource_group_name_kv" {
  type        = string
  description = "The resource group of the Azure Key Vault containing all required secrets and certificates"
}

variable "key_vault_name" {
  type        = string
  description = "Azure Key Vault name containing all required secrets and certificates"
}

# Certificate
# -----------
variable "ca_certificate_name" {
  type        = string
  description = "(Required) Azure Key Vault Certificate name for Application Gateway"
}

variable "tls_certificate_name" {
  type        = string
  description = <<-EOD
  Azure Key Vault Certificate name for certificate provided for Replicated TlsBootstrapCert setting. This
  can be the same certificate name as provided for the ca_certificate_name variable.
  EOD
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
