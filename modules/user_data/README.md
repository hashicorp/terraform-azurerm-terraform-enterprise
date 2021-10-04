# Azure TFE User Data Module

## Required variables

- `friendly_name_prefix` - string value to use as base for resource names
- `resource_group_name` - string value for Azure resource group name
- `location` - string value for Azure location
- `user_data_pg_dbname` - string value for postgres database name
- `user_data_pg_netloc` - string value for postgres database url
- `user_data_pg_user` - string value for postgres database username
- `user_data_pg_password` - stirng value for postgres database password
- `user_data_azure_account_key` - string value for azure storage
  account key
- `user_data_azure_account_name` - string value for azure storage
  account name
- `user_data_azure_container_name` - string value for azure storage
  container name
- `fqdn` - string value for fully qualified domain name
- `tfe_license_secret` - The secret under which the Base64
  encoded Terraform Enterprise license is (or will be) stored in the
  Azure Key Vault
- `ca_certificate` - The PEM formatted public certificate of the
  Certificate Authority in the Azure Key Vault

## Example usage

```hcl
module "user_data" {
  source = "./modules/user_data"

# General
  fqdn          = local.fqdn
  active_active = local.active_active

  # Database
  user_data_pg_dbname   = module.database.database_name
  user_data_pg_netloc   = "${module.database.database_server_fqdn}:5432"
  user_data_pg_user     = "${module.database.database_user}@${module.database.database_server_name}"
  user_data_pg_password = module.database.database_password

  # Redis
  user_data_redis_host        = local.active_active == true ? module.redis[0].redis_hostname : ""
  user_data_redis_port        = local.active_active == true ? local.redis_port : ""
  user_data_redis_pass        = local.active_active == true ? module.redis[0].redis_pass : ""
  user_data_redis_use_tls     = local.active_active == true ? var.user_data_redis_use_tls : true
  redis_enable_authentication = local.active_active == true ? var.redis_enable_authentication : true

  # Azure
  user_data_azure_account_key    = module.service_accounts.storage_account_key
  user_data_azure_account_name   = module.service_accounts.storage_account_name
  user_data_azure_container_name = module.object_storage.storage_account_container_name

  # TFE
  user_data_release_sequence = var.user_data_release_sequence
  tfe_license_secret         = var.tfe_license_secret
  user_data_iact_subnet_list = var.user_data_iact_subnet_list

  # Certificates
  ca_certificate = var.ca_certificate

  # Proxy
  proxy_ip               = var.proxy_ip
  proxy_port             = var.proxy_port
  no_proxy               = [local.fqdn, var.network_cidr]
}
```

## Resources

- [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)
- [random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id)
