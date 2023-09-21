# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "domain_name" {
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "iact_subnet_list" {
  description = "A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed in CIDR notation."
  type        = list(string)
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags for resource"
}

variable "vm_image_id" {
  description = "The resource ID of the base image you would like to use for the airgapped TFE installation."
  type        = string
}