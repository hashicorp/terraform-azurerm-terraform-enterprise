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
variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "storage_account_container_name" {
  type        = string
  description = "Storage account container name"
}

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

variable "storage_account_key" {
  type        = string
  description = "Storage account key"
}

variable "storage_account_primary_blob_connection_string" {
  type        = string
  description = "Storage account primary blob endpoint"
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
