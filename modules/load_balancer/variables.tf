# General
# -------
variable "friendly_name_prefix" {
  type        = string
  description = "(Required) Name prefix used for resources"
}

variable "domain_name" {
  type        = string
  description = "(Required) Domain to create Terraform Enterprise subdomain within"
}

variable "tfe_subdomain" {
  default     = null
  type        = string
  description = "Subdomain for TFE"
}

variable "active_active" {
  default     = true
  type        = bool
  description = "True if TFE running in active-active configuration"
}

# DNS
# ---
variable "dns_create_record" {
  default     = true
  type        = bool
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output."
}

variable "dns_external_fqdn" {
  default     = null
  type        = string
  description = "External DNS FQDN should be supplied if dns_create_record is false"
}

# Provider
# --------
variable "location" {
  type        = string
  description = "(Required) Azure location name e.g. East US"
}

variable "zones" {
  default     = ["1", "2", "3"]
  type        = list(string)
  description = "Azure zones to use for applicable resources"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Azure resource group name"
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault"
}

variable "resource_group_name_dns" {
  type        = string
  description = "Azure resource group name to use for DNS"
}

variable "certificate" {
  type = object({
    key_vault_id = string
    name         = string
    secret_id    = string
  })
  description = "The Azure Key Vault Certificate for the Application Gateway"
}

variable "ca_certificate_secret" {
  type = object({
    name  = string
    value = string
  })
  description = <<-EOD
  A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a
  certificate authority (CA) to be trusted by the Application Gateway.
  EOD
}

# Load balancer
# -------------
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

variable "load_balancer_public" {
  default     = true
  type        = bool
  description = "Load balancer will use public IP if true"
}

variable "load_balancer_enable_http2" {
  default     = true
  type        = bool
  description = "Determine if HTTP2 enabled on Application Gateway"
}


variable "load_balancer_sku_name" {
  default     = "Standard_v2"
  type        = string
  description = "The Name of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_name == "Standard_v2" ||
      var.load_balancer_sku_name == "WAF_v2"
    )

    error_message = "The load_balancer_sku_name value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_sku_tier" {
  default     = "Standard_v2"
  type        = string
  description = "The Tier of the SKU to use for Application Gateway, Standard_v2 or WAF_v2 accepted"

  validation {
    condition = (
      var.load_balancer_sku_tier == "Standard_v2" ||
      var.load_balancer_sku_tier == "WAF_v2"
    )

    error_message = "The load_balancer_sku_tier value must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "load_balancer_waf_firewall_mode" {
  default     = "Prevention"
  type        = string
  description = "The Web Application Firewall mode (Detection or Prevention)"
}

variable "load_balancer_waf_rule_set_version" {
  default     = "3.1"
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1."
}

variable "load_balancer_waf_file_upload_limit_mb" {
  default     = 100
  type        = number
  description = "The File Upload Limit in MB. Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB."
}

variable "load_balancer_waf_max_request_body_size_kb" {
  default     = 128
  type        = number
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB."
}

variable "load_balancer_sku_capacity" {
  default     = 2
  type        = number
  description = "The Capacity of the SKU to use for Application Gateway (1 to 125)"
}

# Network
# -------
variable "network_frontend_subnet_id" {
  type        = string
  description = "(Required) Azure resource ID of frontend subnet for LB/AG"
}

variable "network_private_ip" {
  default     = null
  type        = string
  description = "(optional) Private IP address to use for LB/AG endpoint"
}

variable "network_frontend_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR range for Bastion"
}

# Tagging
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Map of tags for resource"
}
