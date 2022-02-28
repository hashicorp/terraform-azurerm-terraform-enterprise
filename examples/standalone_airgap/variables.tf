variable "domain_name" {
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Name of resource group which contains desired DNS zone"
}

variable "iact_subnet_list" {
  description = <<-EOD
  A list of IP address ranges which will be authorized to access the IACT. The ranges must be expressed
  in CIDR notation.
  EOD
  type        = list(string)
}

variable "vm_image_id" {
  description = <<-EOD
  The resource ID of the base image you would like to use for the airgapped TFE installation.
  EOD
  type        = string

}

variable "tags" {
  type        = map(string)
  description = "Map of tags for resource"
}
