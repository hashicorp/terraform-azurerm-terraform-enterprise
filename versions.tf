# Required Providers
# ------------------
# https://registry.terraform.io/providers/hashicorp/azurerm/latest
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.79"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}