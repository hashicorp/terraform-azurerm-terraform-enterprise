terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.42.0"
    }
  }
}
provider "azurerm" {
  features {}
}