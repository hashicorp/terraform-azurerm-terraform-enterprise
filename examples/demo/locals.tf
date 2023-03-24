# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  common_tags = {
    Environment = "demo-tfe-standalone-mounted-disk"
    Description = "Standalone, Mounted Disk scenario deployed for TEST purposes"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
  }
}