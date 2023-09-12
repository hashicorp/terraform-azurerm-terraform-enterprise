# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "domain_name" {
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "iact_subnet_list" {
  description = "A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed in CIDR notation."
  type        = list(string)
}

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "load_balancer_certificate_name" {
  type        = string
  description = "The name of a Key Vault certificate which will be attached to the application gateway."
}

variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags for resource"
}

variable "vm_certificate_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}

variable "vm_key_secret_name" {
  type        = string
  description = "The name of a Key Vault secret which contains the Base64 encoded version of a PEM encoded private key of a certificate authority (CA) to be trusted by the Virtual Machine Scale Set."
}