locals {
  key_vault_id = var.key_vault_name == null ? azurerm_key_vault.kv[0].id : data.azurerm_key_vault.existing[0].id
}


# Self Signed Certificate
# -----------------------
# CA Key
resource "tls_private_key" "ca" {
  // count = var.user_data_ca == null ? 1 : 0
  count = var.user_data_ca == null && var.load_balancer_public == false ? 1 : 0

  algorithm   = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits    = var.private_key_rsa_bits
}

# CA Cert
resource "tls_self_signed_cert" "ca" {
  // count = var.user_data_ca == null ? 1 : 0
 count = var.user_data_ca == null && var.load_balancer_public == false ? 1 : 0

  is_ca_certificate = true

  key_algorithm   = tls_private_key.ca[0].algorithm
  private_key_pem = tls_private_key.ca[0].private_key_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]

  subject {
    common_name  = "${var.organization_name} Private Certificate Authority"
    organization = var.organization_name
  }
}

# Cert Key
resource "tls_private_key" "cert" {
  // count = var.user_data_cert_key == null ? 1 : 0
  count = var.user_data_cert_key == null && var.load_balancer_type == "load_balancer" ? 1 : 0

  algorithm   = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits    = var.private_key_rsa_bits
}

# Cert Request
resource "tls_cert_request" "cert" {
  // count = var.user_data_cert == null ? 1 : 0
  count = var.user_data_cert == null && var.load_balancer_type == "load_balancer" && var.load_balancer_public == false ? 1 : 0

  key_algorithm   = tls_private_key.cert[0].algorithm
  private_key_pem = tls_private_key.cert[0].private_key_pem

  dns_names = [var.fqdn]

  subject {
    common_name  = var.fqdn
    organization = var.organization_name
  }
}

# Cert
resource "tls_locally_signed_cert" "cert" {
  // count = var.user_data_cert == null ? 1 : 0
  count = var.user_data_cert == null && var.load_balancer_type == "load_balancer" && var.load_balancer_public == false ? 1 : 0

  cert_request_pem = tls_cert_request.cert[0].cert_request_pem

  ca_key_algorithm   = tls_private_key.ca[0].algorithm
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Azure Key Vault
# ---------------

# Reference existing Key Vault if supplied
data "azurerm_key_vault" "existing" {
  count = var.key_vault_name == null ? 0 : 1

  name                = var.key_vault_name
  resource_group_name = var.resource_group_name_kv
}


# Create a new Azure Key Vault if not supplied
resource "azurerm_key_vault" "kv" {
  count = var.key_vault_name == null ? 1 : 0

  name                = "${var.friendly_name_prefix}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name_kv

  tenant_id                   = var.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = var.soft_delete_retention_days
  enabled_for_deployment      = var.enabled_for_deployment
  enabled_for_disk_encryption = var.enabled_for_disk_encryption

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "tfe_kv_acl" {
  count = var.key_vault_name == null ? 1 : 0

  key_vault_id = local.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  certificate_permissions = var.certificate_permissions
  secret_permissions      = var.secret_permissions
}

# Azure Key Vault Certificate
# ---------------------------
resource "azurerm_key_vault_certificate" "cert" {
  count = (var.certificate_name == null || var.key_vault_name == null) && var.load_balancer_type == "application_gateway" ? 1 : 0

  name         = "${var.friendly_name_prefix}cert"
  key_vault_id = local.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = [var.fqdn]
      }

      subject            = "CN=${var.fqdn}"
      validity_in_months = 12
    }
  }

  tags = var.tags
}

# If the TFE license filepath is supplied, then
# store the base64 encoded license in the Key Vault
# -------------------------------------------------
resource "azurerm_key_vault_secret" "tfe_license" {
  count = var.tfe_license_filepath == null ? 0 : 1

  name         = var.tfe_license_secret_name
  value        = filebase64(var.tfe_license_filepath)
  key_vault_id = local.key_vault_id

  depends_on = [azurerm_key_vault_access_policy.tfe_kv_acl]
}