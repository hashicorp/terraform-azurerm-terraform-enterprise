locals {
  common_tags = {
    Terraform   = "False"
    Environment = "${local.friendly_name_prefix}-test-standalone-mounted-disk"
    Description = "Standalone, Mounted Disk scenario deployed from CircleCI"
    Repository  = "hashicorp/terraform-azurerm-terraform-enterprise"
    Team        = "Terraform Enterprise on Prem"
    OkToDelete  = "True"
  }

  utility_module_test  = var.license_file == null
  friendly_name_prefix = random_string.friendly_name.id
}
