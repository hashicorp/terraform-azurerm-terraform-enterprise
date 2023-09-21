# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

variable "is_replicated_deployment" {
  type        = bool
  description = "TFE will be installed using a Replicated license and deployment method."
}

variable "tfe_subdomain" {
  type        = string
  description = "Subdomain for TFE"
}

variable "active_active" {
  type        = bool
  description = "True if TFE running in active-active configuration"
}

variable "enable_ssh" {
  type        = bool
  description = "Enable SSH access on port 22 to the VM instance (standalone, load_balancer deployments only, not App GW). This is ***NOT RECOMMENDED*** for production deployments."
}

# DNS
# ---
variable "dns_create_record" {
  type        = bool
  description = "If true, will create a DNS record. If false, no record will be created and IP of load balancer will instead be output."
}

variable "dns_external_fqdn" {
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
  description = "A Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate of a certificate authority (CA) to be trusted by the Application Gateway."
}

# Load balancer
# -------------
variable "load_balancer_type" {
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
  type        = bool
  description = "Load balancer will use public IP if true"
}

variable "load_balancer_enable_http2" {
  type        = bool
  description = "Determine if HTTP2 enabled on Application Gateway"
}

variable "load_balancer_sku_name" {
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
  type        = string
  description = "The Web Application Firewall mode (Detection or Prevention)"
}

variable "load_balancer_waf_rule_set_version" {
  type        = string
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, 3.1, and 3.2."
}

variable "load_balancer_waf_file_upload_limit_mb" {
  type        = number
  description = "The File Upload Limit in MB. Accepted values are in the range 1MB to 750MB for the WAF_v2 SKU, and 1MB to 500MB for all other SKUs. Defaults to 100MB."
}

variable "load_balancer_waf_max_request_body_size_kb" {
  type        = number
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB."
}

variable "load_balancer_sku_capacity" {
  type        = number
  description = "The Capacity of the SKU to use for Application Gateway (1 to 125)"
}

variable "load_balancer_request_routing_rule_minimum_priority" {
  type        = number
  description = "The minimum priority for request routing rule. Lower priotity numbered rules take precedence over higher priotity number rules."
  validation {
    condition = (
      var.load_balancer_request_routing_rule_minimum_priority > 1 &&
      var.load_balancer_request_routing_rule_minimum_priority < 19000
    )
    error_message = "Request routing rules priority must be between 1 and 19,000."
  }
}

# Network
# -------
variable "network_frontend_subnet_id" {
  type        = string
  description = "(Required) Azure resource ID of frontend subnet for LB/AG"
}

variable "network_private_ip" {
  type        = string
  description = "(optional) Private IP address to use for LB/AG endpoint"
}

variable "network_frontend_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR range for Bastion"
}

# Tagging
variable "tags" {
  type        = map(string)
  description = "Map of tags for resource"
}
