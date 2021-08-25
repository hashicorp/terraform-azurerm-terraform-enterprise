output "storage_account_name" {
  value       = local.storage_account_name
  description = "The name of the storage account used by TFE"
}

output "storage_account_key" {
  value       = local.storage_account_key
  description = "The Primary Access Key for the storage account used by TFE"
}

output "storage_account_primary_blob_connection_string" {
  value       = local.storage_account_primary_blob_connection_string
  description = "The connection string associated with the primary location for the storage account used by TFE"
}

output "vmss_user_assigned_identity" {
  value = azurerm_user_assigned_identity.vmss

  description = "The user assigned identity to be assigned to the virtual machine scale set"
}

output "key_vault_name" {
  value       = data.azurerm_key_vault.kv.name
  description = "The name of the existing Azure Key Vault that houses the bootstrap secrets"
}

output "key_vault_id" {
  value       = data.azurerm_key_vault.kv.id
  description = "The resource ID of the existing Azure Key Vault that houses the bootstrap secrets"
}

output "ca_certificate_name" {
  value       = data.azurerm_key_vault_certificate.ca_cert.name
  description = "The name of the existing CA certificate in the Key Vault"
}

output "ca_certificate_key_vault_secret_id" {
  value       = data.azurerm_key_vault_certificate.ca_cert.secret_id
  description = "The certificate's secret ID (different than resource ID)"
}

output "tls_certificate" {
  value       = var.tls_certificate_name == null ? "" : data.azurerm_key_vault_certificate.tls_certificate[0]
  description = "Certificate provided for Replicated TlsBootstrapCert setting in pfx format. This output supplies the thumbprint, et. al."
}

output "tls_certificate_data" {
  value       = var.tls_certificate_name == null ? "" : data.azurerm_key_vault_certificate_data.tls_certificate[0]
  description = "Certificate provided for Replicated TlsBootstrapCert setting in pfx format. This output supplies the pem, et. al."
}
