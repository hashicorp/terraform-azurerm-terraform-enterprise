# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Name prefix used for resources"
}

# Provider
# --------
variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Azure resource group name"
}

# Database
# --------
variable "database_user" {
  default     = "tfeuser"
  type        = string
  description = "Postgres username"
}

variable "database_machine_type" {
  type        = string
  description = "Postgres sku short name: tier + family + cores"
}

variable "database_size_mb" {
  type        = number
  description = "Postgres storage size in MB"
}

variable "database_version" {
  type        = string
  description = "Postgres version"
}

variable "database_subnet_id" {
  type        = string
  description = "(Required) Network subnet id for database"
}

variable "database_private_dns_zone_id" {
  type        = string
  description = "The identity of the private DNS zone in which the database will be deployed."
}

# ----
variable "database_backup_retention_days" {
  default     = 7
  type        = number
  description = "Backup retention days for the PostgreSQL server. Supported values are between 7 and 35 days"
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
