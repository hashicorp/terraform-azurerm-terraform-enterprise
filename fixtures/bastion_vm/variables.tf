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

# SSH Config
# ----------
variable "tfe_instance_ip_addresses" {
  default     = null
  type        = list(string)
  description = "The internal IP address of the TFE instance."
}

variable "tfe_instance_user_name" {
  default     = null
  type        = string
  description = "The username of the TFE instance."
}

variable "tfe_private_key_path" {
  default     = null
  type        = string
  description = "The private SSH key."
}

variable "tfe_private_key_data_base64" {
  default     = null
  type        = string
  description = "The SSH private key data to use on the bastion VM in order to SSH to the TFE instance."
}

variable "tfe_ssh_config_path" {
  default     = null
  type        = string
  description = "The path to put the ssh-config file for the TFE instance. This will be iterated based on how many instances there are."
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
