output "tls_ca_cert" {
  value = var.user_data_cert == null ? tls_self_signed_cert.ca[0].cert_pem : var.user_data_ca
  description = "Value to be provided for TFE ca_cert setting"
}

output "tls_cert" {
  value = var.user_data_cert == null ? tls_locally_signed_cert.cert[0].cert_pem : var.user_data_cert
  description = "Value to be provided for Replicated TlsBootstrapCert setting"
}

output "tls_key" {
  value = var.user_data_cert == null ? tls_private_key.cert[0].private_key_pem : var.user_data_cert_key
  description = "Value to be provided for Replicated TlsBootstrapKey setting"
}

output "key_vault_name" {
  value       = var.key_vault_name == null ? azurerm_key_vault.kv[0].name : data.azurerm_key_vault.existing[0].name
  description = "The name of the Azure key vault that houses the bootstrap secrets."
}

output "key_vault_id" {
  value       = local.key_vault_id
  description = "The resource ID of the Azure key vault that houses the bootstrap secrets."
}

# If cert name is supplied but key vault is not, then new cert is used.
output "certificate_name" {
  value = var.load_balancer_type == "application_gateway" ? element(concat(azurerm_key_vault_certificate.cert.*.name, data.azurerm_key_vault_certificate.cert.*.name), 0) : ""
  description = "The name of the CA certificate in the key vault"
}

output "certificate_key_vault_secret_id" {
  value = var.load_balancer_type == "application_gateway" ? element(concat(azurerm_key_vault_certificate.cert.*.secret_id, data.azurerm_key_vault_certificate.cert.*.secret_id), 0) : ""
  description = "The resource ID of the key vault"
}
