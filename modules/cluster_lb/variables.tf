# ============================================================ REQUIRED

variable "install_id" {
  type        = string
  description = "A prefix to use for resource names"
}

variable "location" {
  type        = string
  description = "The Azure Location to build into"
}

variable "rg_name" {
  type        = string
  description = "The Azure Resource Group to build into"
}

variable "dns" {
  type = object({
    domain  = string
    rg_name = string
    ttl     = number
  })
  description = "Expects keys: [domain, rg_name, ttl]"
}

variable "lb_port" {
  type        = map(list(string))
  description = "Expects map with format `name: [frontend_port, protocol, backend_port]` for all routes."
}

variable "resource_prefix" {
  type        = string
  description = "Prefix name for resources"
}

# ============================================================ OPTIONAL
variable "lb_probe_interval" {
  type        = number
  description = "The interval for the Loadbalancer healthcheck probe."
  default     = 10
}

variable "lb_probe_unhealthy_threshold" {
  type        = number
  description = "The amount of unhealthy checks before marking a node unhealthy."
  default     = 2
}

variable "additional_tags" {
  type        = "map"
  description = "A map of additional tags to attach to all resources created."
  default     = {}
}

variable "hostname" {
  default     = ""
  description = "hostname for loadbalancer front end to use"
}

# ============================================================ MISC

# LB resource names

locals {
  prefix             = "${var.resource_prefix}-${var.install_id}"
  frontend           = "${local.prefix}-fe"
  frontened_hostname = "${var.hostname != "" ? var.hostname : local.prefix }"

  default_tags = {
    Application = "Terraform Enterprise"
  }

  tags = "${merge(local.default_tags, var.additional_tags)}"
}

