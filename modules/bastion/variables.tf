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

# Network
# -------
variable "bastion_subnet_id" {
  type        = string
  description = "(Required) Network public subnet ID for Bastion Service"
}

# ----
variable "bastion_allocation_method" {
  default     = "Static"
  type        = string
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
}

variable "bastion_sku" {
  default     = "Standard"
  type        = string
  description = "The SKU of the Public IP and Host. Accepted values are Basic and Standard"
}

variable "bastion_tunneling_enabled" {
  default     = true
  type        = bool
  description = "Is Tunneling feature enabled for the Bastion Host."
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
