# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# General
# -------
variable "consolidated_services" {
  default     = false
  type        = bool
  description = "(Required) True if TFE uses consolidated services."
}

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

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

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "vm_certificate_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "vm_key_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "tfe_license_secret_name" {
  type        = string
  description = "Name of the secret under which the Base64 encoded TFE license is stored in the Azure Key Vault"
}

# Proxy & Bastion
# ---------------
variable "ca_certificate_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "ca_key_secret_name" {
  type        = string
  description = <<-EOD
  The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a
  certificate authority (CA).
  EOD
}

variable "proxy_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the proxy."
}

variable "bastion_public_ssh_key_secret_name" {
  type        = string
  description = "The name of the public SSH key secret for the bastion."
}

variable "network_allow_range" {
  default     = null
  type        = string
  description = "Network range to allow access to bastion vm"
}
