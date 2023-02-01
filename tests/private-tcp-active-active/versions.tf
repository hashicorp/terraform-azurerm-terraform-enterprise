# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  backend "remote" {
    organization = "terraform-enterprise-modules-test"

    workspaces {
      name = "azure-private-tcp-active-active"
    }
  }

  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
provider "azurerm" {
  features {}
}
