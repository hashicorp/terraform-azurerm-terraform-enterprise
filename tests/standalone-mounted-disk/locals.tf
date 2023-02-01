# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  common_tags = {
    Terraform   = "False"
    Environment = "${local.friendly_name_prefix}-test-standalone-mounted-disk"
    Description = "Standalone, Mounted Disk scenario deployed from CircleCI"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }
  vm_image_id = (
    var.vm_image_publisher != null &&
    var.vm_image_offer != null &&
    var.vm_image_sku != null &&
    var.vm_image_version != null
  ) ? "manual" : "ubuntu"
  vm_image_publisher = (
    var.vm_image_publisher != null &&
    var.vm_image_offer != null &&
    var.vm_image_sku != null &&
    var.vm_image_version != null
  ) ? var.vm_image_publisher : null
  vm_image_offer = (
    var.vm_image_publisher != null &&
    var.vm_image_offer != null &&
    var.vm_image_sku != null &&
    var.vm_image_version != null
  ) ? var.vm_image_offer : null
  vm_image_sku = (
    var.vm_image_publisher != null &&
    var.vm_image_offer != null &&
    var.vm_image_sku != null &&
    var.vm_image_version != null
  ) ? var.vm_image_sku : null
  vm_image_version = (
    var.vm_image_publisher != null &&
    var.vm_image_offer != null &&
    var.vm_image_sku != null &&
    var.vm_image_version != null
  ) ? var.vm_image_version : null
  utility_module_test  = var.license_file == null
  friendly_name_prefix = random_string.friendly_name.id
}
