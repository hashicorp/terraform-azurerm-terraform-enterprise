# ============================================================ REQUIRED

variable "install_id" {
  type        = "string"
  description = "A prefix to use for resource names"
}

variable "location" {
  type        = "string"
  description = "The Azure Location to build into"
}

variable "rg_name" {
  type        = "string"
  description = "The Azure Resource Group to build into"
}

variable "dns" {
  type        = "map"
  description = "Expects keys: [domain, rg_name, ttl]"
}

variable "lb_port" {
  type        = "map"
  description = "Expects map with format `name: [frontend_port, protocol, backend_port]` for all routes."
}

# ============================================================ OPTIONAL
variable "lb_probe_interval" {
  default     = 10
  description = "The interval for the Loadbalancer healthcheck probe."
}

variable "lb_probe_unhealthy_threshold" {
  default     = 2
  description = "The amount of unhealthy checks before marking a node unhealthy."
}

# ============================================================ MISC

# LB resource names

locals {
  prefix   = "tfe-${var.install_id}"
  frontend = "${local.prefix}-fe"
}
