locals {
  common_tags = {
    Terraform   = "False"
    Environment = "${local.friendly_name_prefix}-test-standalone-external"
    Description = "Standalone, External Services scenario deployed from CircleCI"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

  friendly_name_prefix = random_string.friendly_name.id
}
