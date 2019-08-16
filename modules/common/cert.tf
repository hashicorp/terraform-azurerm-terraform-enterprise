resource "azurerm_key_vault_certificate" "ptfe" {
  name         = "${local.prefix}-ssl-cert"
  key_vault_id = "${data.azurerm_key_vault.selected.id}"

  certificate {
    contents = "${base64encode(file(var.tls["pfx_cert"])) }"
    password = "${var.tls["pfx_cert_pw"]}"
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"

      # ^ This is only cuz it's a self imported cert
      # It can be signed by a CA, it's just not integrated
      # into the key vault signing process.
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
