terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.79"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}
provider "azurerm" {
  features {}
}
