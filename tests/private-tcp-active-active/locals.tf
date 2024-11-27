# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  common_tags = {
    Environment = "${local.friendly_name_prefix}-test-private-tcp-active-active"
    Description = "Private TCP Active/Active"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise"
    OkToDelete  = "True"
  }

  friendly_name_prefix      = random_string.friendly_name.id
  network_proxy_subnet_cidr = "10.0.80.0/20"
  proxy_user                = "proxyuser"
  proxy_port                = "3128"
  registry                  = "quay.io"
  resource_group_name       = module.private_tcp_active_active.resource_group_name
}
