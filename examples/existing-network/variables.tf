# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "domain_name" {
  type        = string
  description = "Domain to create Terraform Enterprise subdomain within"
}

variable "iact_subnet_list" {
  default     = []
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "load_balancer_certificate_name" {
  type        = string
  description = "The name of a Key Vault certificate which will be attached to the application gateway."
}

variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "license_file" {
  type        = string
  description = "The local path to the Terraform Enterprise license to be provided by CI."
}

variable "key_vault_id" {
  type        = string
  description = "The identity of the Key Vault which contains secrets and certificates."
}

variable "network_bastion_subnet_id" {
  type        = string
  description = "(Optional) Existing network Bastion subnet ID"
}

variable "network_database_private_dns_zone_id" {
  type        = string
  description = "The identity of an existing private DNS zone for the database."
}

variable "network_database_subnet_id" {
  type        = string
  description = "The identity of an existing database subnetwork."
}

variable "network_frontend_subnet_id" {
  type        = string
  description = "(Optional) Existing network frontend subnet ID"
}

variable "network_private_subnet_id" {
  type        = string
  description = "(Optional) Existing network private subnet ID"
}

variable "network_redis_subnet_id" {
  type        = string
  description = "(Optional) Existing network Redis subnet ID"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Azure resource group name"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
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

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}