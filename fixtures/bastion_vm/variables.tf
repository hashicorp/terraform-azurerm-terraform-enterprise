# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "friendly_name_prefix" {
  type        = string
  description = "Name prefix used for resources"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name into which to provision the Bastion virtual machine. Must be an exiting resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network into which to provision the Bastion virtual machine."
}
variable "bastion_subnet_cidr" {
  type        = string
  description = "Subnet CIDR range for Bastion virtual machine."
}

variable "bastion_user" {
  type        = string
  description = "Admin user for the Bastion virtual machine."
}

variable "ssh_public_key" {
  type        = string
  description = "The public SSH key for the Bastion virtual machine."
}

variable "network_allow_range" {
  type        = string
  description = "Network range to allow access to Bastion virtual machine."
}

variable "bastion_custom_data" {
  type        = string
  description = "A Base64 encoded string to use for the cloud-init custom data of the bastion vm."
  default     = null  
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
