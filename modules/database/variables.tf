# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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
  type        = string
  description = "Postgres username"
}

variable "database_extensions" {
  type        = list(string)
  description = "A list of PostgreSQL extensions to enable."
}

variable "database_machine_type" {
  type        = string
  description = "Postgres sku short name: tier + family + cores"
}

variable "database_size_mb" {
  type        = number
  description = "Postgres storage size in MB"
}

variable "public_network_access_enabled" {
  default     = "false"
  type        = string
  description = "Public network access with virtual network interface"
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

variable "database_backup_retention_days" {
  type        = number
  description = "Backup retention days for the PostgreSQL server."

  validation {
    condition = (
      var.database_backup_retention_days >= 7 &&
      var.database_backup_retention_days <= 35
    )

    error_message = "Supported values for database_backup_retention_days are between 7 and 35 days."
  }
}

variable "database_availability_zone" {
  type        = number
  description = "The Availability Zone of the PostgreSQL Flexible Server."

  validation {
    condition = (
      var.database_availability_zone == 1 ||
      var.database_availability_zone == 2 ||
      var.database_availability_zone == 3
    )

    error_message = "Possible values for database_availability_zone are 1, 2 and 3."
  }
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}

variable "database_msi_auth_enabled" {
  default     = false
  type        = bool
  description = "If true, Managed Identity authentication will be enabled for the PostgreSQL server. If false, password authentication will be used."
}

variable "user_assigned_identity" {
  type = object({
    id           = string
    name         = string
    client_id    = string
    principal_id = string
    tenant_id    = string
  })
}
