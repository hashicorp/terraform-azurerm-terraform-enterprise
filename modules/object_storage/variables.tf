# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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
  type        = string
  description = "Storage account tier Standard or Premium"
}

variable "storage_account_replication_type" {
  type        = string
  description = <<-EOD
  Storage account type LRS, GRS, RAGRS, ZRS. NOTE: This is defaulted to 'GRS' because of a known
  intermittent error sited here: https://github.com/hashicorp/terraform-provider-azurerm/issues/5299
  EOD

  validation {
    condition = (
      var.storage_account_replication_type == "LRS" ||
      var.storage_account_replication_type == "GRS" ||
      var.storage_account_replication_type == "RAGRS" ||
      var.storage_account_replication_type == "ZRS" ||
      var.storage_account_replication_type == null
    )

    error_message = "Supported values for storage_account_replication_type are 'LRS', 'GRS', 'RAGRS', and 'ZRS'."
  }
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
  type        = map(string)
  description = "Map of tags for resource"
}
