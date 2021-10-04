# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "Name prefix used for resources"
}

# Provider
# --------
variable "location" {
  type        = string
  description = "Azure location name e.g. East US"
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault"
}

variable "zones" {
  default     = ["1", "2", "3"]
  type        = list(string)
  description = "Azure zones to use for applicable resources"
}

variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "load_balancer_type" {
  default     = "application_gateway"
  type        = string
  description = "Expected value of 'application_gateway' or 'load_balancer'"
  validation {
    condition = (
      var.load_balancer_type == "application_gateway" ||
      var.load_balancer_type == "load_balancer"
    )

    error_message = "The load_balancer_type value must be 'application_gateway' or 'load_balancer'."
  }
}

# Load balancer
# -------------
variable "load_balancer_backend_id" {
  type        = string
  description = "The backend address pool ID of the load balancer or application gateway"
}

variable "load_balancer_public" {
  default     = true
  type        = bool
  description = "Load balancer will use public IP if true"
}

# Vm
# --
variable "vm_node_count" {
  default     = 1
  type        = number
  description = "The number of instances to create for TFE environment"

  validation {
    condition     = var.vm_node_count <= 5
    error_message = "The vm_node_count value must be less than or equal to 5."
  }
}

variable "vm_userdata_script" {
  type        = string
  description = "The custom data script that will provision the TFE instance(s)"
}

variable "vm_subnet_id" {
  type        = string
  description = "Network subnet id for vm"
}

variable "vm_user" {
  type        = string
  description = "Virtual machine user name"
}

variable "vm_public_key" {
  type        = string
  description = "Virtual machine ssh public key"
}

variable "vm_image_id" {
  default     = "ubuntu"
  type        = string
  description = "Virtual machine image id - may be 'ubuntu' (default), 'rhel', or custom image resource id"

  validation {
    condition = (
      var.vm_image_id == "ubuntu" ||
      var.vm_image_id == "rhel" ||
      substr(var.vm_image_id, 0, 14) == "/subscriptions"
    )

    error_message = "The vm_image_id value must be 'ubuntu', 'rhel', or an Azure image resource ID beginning with \"/subscriptions\"."
  }
}

variable "ca_certificate_secret" {
  type = object({
    key_vault_id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate
  authority (CA) to be trusted by the Virtual Machine Scale Set.
  EOD
}

variable "certificate_secret" {
  type = object({
    key_vault_id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual
  Machine Scale Set.
  EOD
}

variable "key_secret" {
  type = object({
    key_vault_id = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine
  Scale Set.
  EOD
}

# Optional variables not currently specified in root module
variable "vm_overprovision" {
  default     = false
  type        = bool
  description = "Should Azure over-provision Virtual Machines in this Scale Set?"
}

variable "vm_sku" {
  default     = "Standard_D4_v3"
  type        = string
  description = "Azure virtual machine sku"
}

variable "vm_upgrade_mode" {
  default     = "Manual"
  type        = string
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual."
}

variable "vm_zone_balance" {
  default     = true
  type        = bool
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Defaults to false. Changing this forces a new resource to be created."
}

variable "vm_os_disk_caching" {
  default     = "ReadWrite"
  type        = string
  description = "The type of Caching which should be used for this Data Disk. Possible values are None, ReadOnly and ReadWrite."
}

variable "vm_os_disk_storage_account_type" {
  default     = "StandardSSD_LRS"
  type        = string
  description = "The Type of Storage Account which should back this Data Disk. Possible values include Standard_LRS, StandardSSD_LRS, Premium_LRS and UltraSSD_LRS."
}

variable "vm_os_disk_disk_size_gb" {
  default     = 100
  type        = number
  description = "The size of the Data Disk which should be created"
}

variable "vm_identity_type" {
  default     = "UserAssigned"
  type        = string
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine Scale Set. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned."
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
