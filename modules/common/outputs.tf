output "rg_name" {
  value       = "${data.azurerm_resource_group.selected.name}"
  description = "The Azure Resource Group to use."
}

output "rg_location" {
  value       = "${data.azurerm_resource_group.selected.location}"
  description = "The Location the Azure Resource Group is in."
}

output "vnet_id" {
  value       = "${data.azurerm_virtual_network.selected.id}"
  description = "The id of the Azure Virtual Network to use."
}

output "vnet_name" {
  value       = "${data.azurerm_virtual_network.selected.name}"
  description = "The name of the Azure Virtual Network to use."
}

output "app_subnet_id" {
  value       = "${data.azurerm_subnet.app_selected.id}"
  description = "The id of the Subnet within the Azure Virtual Network to use."
}

output "app_subnet_name" {
  value       = "${data.azurerm_subnet.app_selected.name}"
  description = "The name of the Subnet within the Azure Virtual Network to use."
}

output "ssh_public_key" {
  value       = "${tls_private_key.default.public_key_openssh}"
  description = "The value of the generated ssh public key to use for instance login."
}

output "ssh_private_key_path" {
  value       = "${local.private_key_filename}"
  description = "The path to the associated private key file to the public key used for instance login."
}

output "vault_id" {
  value       = "${data.azurerm_key_vault.selected.id}"
  description = "The id of the Azure Key Vault to use."
}

output "cert_secret_id" {
  value       = "${azurerm_key_vault_certificate.ptfe.secret_id}"
  description = "The id of the Azure Key Vault certificate object generated from the provided PFX certificate."
}

output "cert_data" {
  value       = "${data.azurerm_key_vault_secret.ptfe.value}"
  description = "The data of the provided certificate."
}

output "cert_pass" {
  value       = "${var.tls["pfx_cert_pw"]}"
  description = "The password for the provided certificate"
}

output "domain_rg_name" {
  value       = "${local.rendered_domain_rg_name}"
  description = "The Azure Resource Group the domain/dns zone exists in."
}

output "cert_thumbprint" {
  value       = "${azurerm_key_vault_certificate.ptfe.thumbprint}"
  description = "The thumbprint for the Azure Key Vault Certificate object generated from the provided PFX certificate."
}
