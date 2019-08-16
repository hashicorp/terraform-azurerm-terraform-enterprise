# ============================================================ REQUIRED

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

variable "os_disk_size" {
  type        = "string"
  description = "Specifies the size of the OS Disk in gigabytes."
}

variable "username" {
  type        = "string"
  description = "Specifies the name of the local administrator account."
}

variable "cluster_backend_pool_id" {
  type        = "string"
  description = "The id of the backend pool for the cluster loadbalancer."
}

variable "cloud_init_data_list" {
  type        = "list"
  description = "List of rendered cloud-init templates to pass to the vms."
}

variable "storage_image" {
  type        = "map"
  description = "Expects keys: [publisher, offer, sku, version]"
}

variable "vm" {
  type        = "map"
  description = "Expects keys: [count, size]"
}

variable "ssh" {
  type        = "map"
  description = "Expects keys: [public_key, private_key_path]"
}

variable "key_vault" {
  type        = "map"
  description = "Expects keys: [id, cert_uri]"
}

# ============================================================ MISC

locals {
  prefix = "tfe-${var.install_id}-primary"

  ip_conf_name = "${local.prefix}-ip-conf"

  ssh_config_path = "${path.root}/work/ssh_config"
}
