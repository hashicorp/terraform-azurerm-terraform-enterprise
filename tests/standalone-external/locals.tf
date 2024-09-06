# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  common_tags = {
    Environment = "${local.friendly_name_prefix}-test-standalone-external"
    Description = "Standalone, External Services scenario"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise"
    OkToDelete  = "True"
  }

  friendly_name_prefix = random_string.friendly_name.id
  registry             = "quay.io"
  utility_module_test  = var.license_file == null
}
