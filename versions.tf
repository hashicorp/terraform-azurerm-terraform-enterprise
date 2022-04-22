# Required Providers
# ------------------
# https://registry.terraform.io/providers/hashicorp/azurerm/latest
terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3"
    }
  }
}
provider "azurerm" {
  features {}
}

