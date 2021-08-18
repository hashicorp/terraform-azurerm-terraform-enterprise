output "key_vault_name" {
  value       = data.azurerm_key_vault.existing.name
  description = "The name of the existing Azure key vault that houses the bootstrap secrets"
}

output "key_vault_id" {
  value       = data.azurerm_key_vault.existing.id
  description = "The resource ID of the existing Azure key vault that houses the bootstrap secrets"
}

output "certificate_name" {
  value       = data.azurerm_key_vault_certificate.cert.name
  description = "The name of the existing CA certificate in the key vault"
}

output "certificate_key_vault_secret_id" {
  value       = data.azurerm_key_vault_certificate.cert.secret_id
  description = "The certificate's secret ID (different than resource ID)"
}
