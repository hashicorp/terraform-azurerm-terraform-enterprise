# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  common_tags = {
    Environment = "${local.friendly_name_prefix}-test-public-active-active"
    Description = "Public Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise"
    OkToDelete  = "True"
  }

  friendly_name_prefix = random_string.friendly_name.id
  registry             = "quay.io"
}
