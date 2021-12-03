locals {
  # Determine private IP address based on CIDR range if not already supplied and if load balancer public is false
  private_ip_address = var.network_private_ip == null && var.load_balancer_public == false ? cidrhost(var.network_frontend_subnet_cidr, 16) : var.network_private_ip

  # Determine the resulting TFE IP
  tfe_subdomain     = var.tfe_subdomain == null ? substr(random_pet.tfe_subdomain[0].id, 0, 24) : var.tfe_subdomain
  load_balancer_ip  = var.load_balancer_public == true ? azurerm_public_ip.tfe_pip.ip_address : local.private_ip_address
  dns_internal_fqdn = var.domain_name == null ? azurerm_public_ip.tfe_pip.fqdn : "${local.tfe_subdomain}.${var.domain_name}"
  fqdn              = var.dns_external_fqdn == null ? local.dns_internal_fqdn : var.dns_external_fqdn

  is_legacy_rule_set_version = var.load_balancer_waf_rule_set_version == "2.2.9"

  # Application Gateway
  # -------------------
  gateway_ip_configuration_name          = "tfe-ag-gateway-ip-config"
  frontend_ip_configuration_name_public  = "tfe-ag-frontend-ip-config-pub"
  frontend_ip_configuration_name_private = "tfe-ag-frontend-ip-config-priv"
  frontend_ip_configuration_name         = var.load_balancer_public == true ? local.frontend_ip_configuration_name_public : local.frontend_ip_configuration_name_private
  backend_address_pool_name              = "tfe-ag-backend-address-pool"
  rewrite_rule_set_name                  = "tfe-ag-rewrite_rules"

  # TFE Application Configuration
  app_frontend_port_name          = "tfe-ag-frontend-port-app"
  app_frontend_http_listener_name = "tfe-ag-http-listener-frontend-port-app"
  app_backend_http_settings_name  = "tfe-ag-backend-http-settings-app"
  app_request_routing_rule_name   = "tfe-ag-routing-rule-app"

  # TFE Console Configuration (standalone only)
  console_frontend_port_name          = "tfe-ag-frontend-port-console"
  console_frontend_http_listener_name = "tfe-ag-http-listener-frontend-port-console"
  console_backend_http_settings_name  = "tfe-ag-backend-http-settings-console"
  console_request_routing_rule_name   = "tfe-ag-routing-rule-console"

  trusted_root_certificates      = var.ca_certificate_secret == null ? {} : { (var.ca_certificate_secret.name) = var.ca_certificate_secret.value }
  trusted_root_certificate_names = keys(local.trusted_root_certificates)
}

# Subdomain
# ---------
resource "random_pet" "tfe_subdomain" {
  count = var.tfe_subdomain == null ? 1 : 0

  length    = 2
  separator = ""
}

# Public IP
# ---------
resource "azurerm_public_ip" "tfe_pip" {
  name                = "${var.friendly_name_prefix}-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"
  domain_name_label = var.domain_name == null ? local.tfe_subdomain : null

  tags = var.tags
}

# New DNS Record
# --------------
resource "azurerm_dns_a_record" "tfe_pip_dns" {
  count = var.domain_name != null && var.dns_create_record == true ? 1 : 0

  name                = local.tfe_subdomain
  zone_name           = var.domain_name
  resource_group_name = var.resource_group_name_dns
  ttl                 = 300

  # Public
  target_resource_id = var.load_balancer_public == true ? azurerm_public_ip.tfe_pip.id : null

  # Private
  records = var.load_balancer_public == false ? [local.private_ip_address] : null

  tags = var.tags
}

# Managed Service Identity
# ------------------------
resource "azurerm_user_assigned_identity" "tfe_ag_msi" {
  count = var.load_balancer_type == "application_gateway" ? 1 : 0

  name                = "${var.friendly_name_prefix}-msi"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Key Vault Policy - allow 'get' permission for application gateway managed identity
# ----------------
resource "azurerm_key_vault_access_policy" "tfe_kv_acl" {
  count = var.load_balancer_type == "application_gateway" ? 1 : 0

  key_vault_id = var.certificate.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.tfe_ag_msi[0].principal_id

  certificate_permissions = [
    "get",
    "list"
  ]

  secret_permissions = [
    "get",
    "list"
  ]
}

# Application Gateway
# -------------------
resource "azurerm_application_gateway" "tfe_ag" {
  count = var.load_balancer_type == "application_gateway" ? 1 : 0

  depends_on = [
    # This explicit dependency is required to ensure that the access policy is created before the application gateway.
    # It is not possible to use the the object ID of the access policy as the identity ID of the application gateway
    # as they are required to be different values of the user assigned identity (principal ID versus ID).
    azurerm_key_vault_access_policy.tfe_kv_acl
  ]

  name                = "${var.friendly_name_prefix}-ag"
  resource_group_name = var.resource_group_name
  location            = var.location

  enable_http2 = var.load_balancer_enable_http2
  zones        = var.zones

  sku {
    name     = var.load_balancer_sku_name
    tier     = var.load_balancer_sku_tier
    capacity = var.load_balancer_sku_capacity
  }

  rewrite_rule_set {
    name = local.rewrite_rule_set_name

    rewrite_rule {
      name          = "remove_port_from_headers"
      rule_sequence = 100
      request_header_configuration {
        header_name  = "X-Forwarded-For"
        header_value = "{var_add_x_forwarded_for_proxy}"
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = var.load_balancer_sku_name == "WAF_v2" ? [1] : []

    content {
      enabled          = true
      firewall_mode    = var.load_balancer_waf_firewall_mode
      rule_set_type    = "OWASP"
      rule_set_version = var.load_balancer_waf_rule_set_version

      # Allow HTTP header "Content-Type: application/vnd.api+json" for API requests
      disabled_rule_group {
        rule_group_name = local.is_legacy_rule_set_version ? "crs_30_http_policy" : "REQUEST-920-PROTOCOL-ENFORCEMENT"

        rules = local.is_legacy_rule_set_version ? [960010] : [920420]
      }
      file_upload_limit_mb     = var.load_balancer_waf_file_upload_limit_mb
      max_request_body_size_kb = var.load_balancer_waf_max_request_body_size_kb
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.tfe_ag_msi[0].id]
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.network_frontend_subnet_id
  }

  ssl_certificate {
    name                = var.certificate.name
    key_vault_secret_id = var.certificate.secret_id
  }

  ssl_policy {
    # AppGwSslPolicy20170401S requires >= TLSv1_2
    policy_name = "AppGwSslPolicy20170401S"
    policy_type = "Predefined"
  }

  dynamic "trusted_root_certificate" {
    for_each = local.trusted_root_certificates
    content {
      name = trusted_root_certificate.key
      data = trusted_root_certificate.value
    }
  }

  # Public front end configuration
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name_public
    public_ip_address_id = azurerm_public_ip.tfe_pip.id
  }

  # Private front end configuration
  dynamic "frontend_ip_configuration" {
    for_each = var.load_balancer_public == false ? [1] : []

    content {
      name                          = local.frontend_ip_configuration_name_private
      subnet_id                     = var.network_frontend_subnet_id
      private_ip_address_allocation = "Static"
      private_ip_address            = local.private_ip_address
    }
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  # TFE Application
  frontend_port {
    name = local.app_frontend_port_name
    port = 443
  }

  http_listener {
    name                           = local.app_frontend_http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.app_frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.certificate.name
  }

  backend_http_settings {
    name                  = local.app_backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path                  = ""
    protocol              = "Https"
    port                  = 443
    request_timeout       = 60
    host_name             = local.fqdn

    trusted_root_certificate_names = local.trusted_root_certificate_names
  }

  request_routing_rule {
    name                       = local.app_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.app_frontend_http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.app_backend_http_settings_name
    rewrite_rule_set_name      = local.rewrite_rule_set_name
  }

  # TFE Console
  dynamic "frontend_port" {
    for_each = var.active_active == false ? [1] : []

    content {
      name = local.console_frontend_port_name
      port = 8800
    }
  }

  dynamic "http_listener" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                           = local.console_frontend_http_listener_name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.console_frontend_port_name
      protocol                       = "Https"
      ssl_certificate_name           = var.certificate.name
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                  = local.console_backend_http_settings_name
      cookie_based_affinity = "Disabled"
      path                  = ""
      protocol              = "Https"
      port                  = 8800
      request_timeout       = 60
      host_name             = local.fqdn

      trusted_root_certificate_names = local.trusted_root_certificate_names
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.active_active == false ? [1] : []

    content {
      name                       = local.console_request_routing_rule_name
      rule_type                  = "Basic"
      http_listener_name         = local.console_frontend_http_listener_name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.console_backend_http_settings_name
    }
  }

  lifecycle {
    ignore_changes = [identity[0].identity_ids]
  }

  tags = var.tags
}

# Load balancer
# -------------
resource "azurerm_lb" "tfe_load_balancer" {
  count = var.load_balancer_type == "load_balancer" ? 1 : 0

  name                = "${var.friendly_name_prefix}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Standard"

  # Public front end configuration
  dynamic "frontend_ip_configuration" {
    for_each = var.load_balancer_public == true ? [1] : []

    content {
      name                 = "${var.friendly_name_prefix}-lb-fe"
      public_ip_address_id = azurerm_public_ip.tfe_pip.id
    }
  }

  # Private front end configuration
  dynamic "frontend_ip_configuration" {
    for_each = var.load_balancer_public == false ? [1] : []

    content {
      name                          = "${var.friendly_name_prefix}-lb-fe"
      subnet_id                     = var.network_frontend_subnet_id
      private_ip_address_allocation = "Static"
      private_ip_address            = local.private_ip_address
    }
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "tfe_load_balancer_be" {
  count = var.load_balancer_type == "load_balancer" ? 1 : 0

  name            = "${var.friendly_name_prefix}-lb-be"
  loadbalancer_id = azurerm_lb.tfe_load_balancer[0].id
}

resource "azurerm_lb_probe" "tfe_load_balancer_probe_console" {
  count = var.load_balancer_type == "load_balancer" && var.active_active == false ? 1 : 0

  name                = "${var.friendly_name_prefix}-lb-probe-console"
  resource_group_name = var.resource_group_name

  loadbalancer_id = azurerm_lb.tfe_load_balancer[0].id
  protocol        = "Https"
  request_path    = "/authenticate"
  port            = 8800
}

resource "azurerm_lb_rule" "tfe_load_balancer_rule_console" {
  count = var.load_balancer_type == "load_balancer" && var.active_active == false ? 1 : 0

  name                = "${var.friendly_name_prefix}-lb-rule-console"
  resource_group_name = var.resource_group_name

  loadbalancer_id                = azurerm_lb.tfe_load_balancer[0].id
  probe_id                       = azurerm_lb_probe.tfe_load_balancer_probe_console[0].id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "${var.friendly_name_prefix}-lb-fe"
  frontend_port                  = 8800
  backend_address_pool_id        = azurerm_lb_backend_address_pool.tfe_load_balancer_be[0].id
  backend_port                   = 8800
}

resource "azurerm_lb_probe" "tfe_load_balancer_probe_app" {
  count = var.load_balancer_type == "load_balancer" ? 1 : 0

  name                = "${var.friendly_name_prefix}-lb-probe-app"
  resource_group_name = var.resource_group_name

  loadbalancer_id = azurerm_lb.tfe_load_balancer[0].id
  protocol        = "Https"
  request_path    = "/_health_check"
  port            = 443
}

resource "azurerm_lb_rule" "tfe_load_balancer_rule_app" {
  count = var.load_balancer_type == "load_balancer" ? 1 : 0

  name                = "${var.friendly_name_prefix}-lb-rule-app"
  resource_group_name = var.resource_group_name

  loadbalancer_id                = azurerm_lb.tfe_load_balancer[0].id
  probe_id                       = azurerm_lb_probe.tfe_load_balancer_probe_app[0].id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "${var.friendly_name_prefix}-lb-fe"
  frontend_port                  = 443
  backend_address_pool_id        = azurerm_lb_backend_address_pool.tfe_load_balancer_be[0].id
  backend_port                   = 443
}
