# === Required

variable "install_id" {
  type        = "string"
  description = "A prefix to use for resource names"
}

variable "rg_name" {
  type        = "string"
  description = "The Azure Resource Group to build into"
}

variable "location" {
  type        = "string"
  description = "The Azure Location to build into"
}

variable "subnet_id" {
  type        = "string"
  description = "The Azure Subnet to build into"
}

variable "ssh_public_key" {
  type        = "string"
  description = "The ssh public key to give to all vms in the scale-set for the local administrator account."
}

variable "username" {
  type        = "string"
  description = "Specifies the name of the local administrator account."
}

variable "cloud_init_data" {
  type        = "string"
  description = "Rendered cloud-init template to pass to the vms."
}

variable "storage_image" {
  type        = "map"
  description = "Expects keys: [publisher, offer, sku, version]"
}

variable "vm" {
  type        = "map"
  description = "Expects keys: [size, count, size_tier]"
}

variable "resource_prefix" {
  type        = "string"
  description = "Prefix name for resources"
}

#  ============================================================ OPTIONAL

variable "additional_tags" {
  type        = "map"
  description = "A map of additional tags to attach to all resources created."
  default     = {}
}

# === Misc

locals {
  prefix = "${var.resource_prefix}-${var.install_id}"

  default_tags = {
    Application = "Terraform Enterprise"
  }

  tags = "${merge(local.default_tags, var.additional_tags)}"
}
