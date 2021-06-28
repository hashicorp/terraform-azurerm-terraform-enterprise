variable "vm_public_ip" {
  default     = false
  type        = bool
  description = "If true, will create a public IP resource and associate with VM NIC."
}

variable "vm_userdata_script" {
  default = ""
  type    = string
}

variable "vm_userdata_http_proxy_port" {
  default = "3128"
  type    = string
}

# Network
# -------
variable "network_allow_range" {
  default     = "*"
  type        = string
  description = "Network range to allow access to TFE"
}

variable "network_subnet_cidr" {
  default     = "10.0.64.0/20"
  type        = string
  description = "Subnet CIDR range for additional compute instance"
}

variable "network_bastion_subnet_cidr" {
  default     = "10.0.16.0/20"
  type        = string
  description = "(Optional) Subnet CIDR range for Bastion"
}

# Tagging
# -------
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
