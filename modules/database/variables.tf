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
  default     = "GP_Gen5_4"
  type        = string
  description = "Postgres sku short name: tier + family + cores"
}

variable "database_size_mb" {
  default     = 5120
  type        = number
  description = "Postgres storage size in MB"
}

variable "database_version" {
  default     = "9.6"
  type        = string
  description = "Postgres version"
}

variable "database_subnet" {
  type        = string
  description = "(Required) Network subnet id for database"
}

# ----
variable "database_backup_retention_days" {
  default     = 7
  type        = number
  description = "Backup retention days for the PostgreSQL server. Supported values are between 7 and 35 days."
}

variable "database_geo_redundant_backup_enabled" {
  default     = true
  type        = bool
  description = <<DESC
  Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant
  backup storage in the General Purpose and Memory Optimized tiers.
  DESC
}

variable "database_auto_grow_enabled" {
  default     = true
  type        = bool
  description = "Enable/Disable auto-growing of the storage for PostgreSQL server."
}

variable "database_ssl_enforcement_enabled" {
  default     = true
  type        = bool
  description = "Specifies if SSL should be enforced on connections."
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
