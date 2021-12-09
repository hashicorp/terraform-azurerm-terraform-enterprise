# FIXTURE: TFE Secrets Module

This module will create all of the Azure Key Vault Secrets that are required by the root TFE module as well as fixture modules that available for use in this repository. This will only create secrets for the variables for which **you provide values**, not for variables whose values are null.

## Example usage

```hcl
resource "tls_private_key" "proxy_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "secrets" {
  source = "./fixtures/secrets"

  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-tfe-rg/providers/Microsoft.KeyVault/vaults/my-tfe-kv"
  
  tfe_license = {
    name = "my-tfe-license"
    path = "/path/to/license.rli"
  }

  # examples of when the value is in a file
  private_key_pem = {
    name  = "my-private-key-pem"
    value = file("/path/to/private-key.pem")
  }
  chained_certificate_pem = {
    name  = "my-chained-cert-pem"
    value = file("/path/to/chained-certificate.pem")
  }

  # examples of when the value comes from the output of a resource
  proxy_public_key = {
    name  = "my-proxy-public-key"
    value = tls_private_key.proxy_ssh.public_key_openssh
  }

  proxy_private_key = {
    name  = "my-proxy-private-key"
    value = tls_private_key.proxy_ssh.private_key_pem
  }
}
```

## Resources

* [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)
