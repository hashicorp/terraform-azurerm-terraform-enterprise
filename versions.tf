# Required Providers
# ------------------
# https://registry.terraform.io/providers/hashicorp/azurerm/latest
terraform {
  required_version = ">= 1.0.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

