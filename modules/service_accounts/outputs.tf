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

output "certificate_name" {
  value       = data.azurerm_key_vault_certificate.certificate.name
  description = "The name of the existing certificate in the Key Vault"
}

output "certificate_key_vault_secret_id" {
  value       = data.azurerm_key_vault_certificate.certificate.secret_id
  description = "The certificate's secret ID (different than resource ID)"
}

output "trusted_root_certificate" {
  value       = var.trusted_root_certificate_name == null ? "" : data.azurerm_key_vault_certificate.trusted_root_certificate[0]
  description = "Name of the certificate provided for the Application Gateway's trusted root certificate"
}

output "trusted_root_certificate_data" {
  value       = var.trusted_root_certificate_name == null ? "" : data.azurerm_key_vault_certificate_data.trusted_root_certificate[0]
  description = "Data of the certificate provided for the Application Gateway's trusted root certificate"
}
