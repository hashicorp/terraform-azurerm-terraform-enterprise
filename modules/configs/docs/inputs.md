# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| airgap | Expects keys: [enable, package_url, installer_url] | map | n/a | yes |
| assistant\_port | Port the assitant sidecar-like node service is running on. | string | n/a | yes |
| azure\_es | Expects keys: [enable, account_name, account_key, container] | map | n/a | yes |
| ca\_cert\_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections | string | n/a | yes |
| cert\_thumbprint | The thumbprint for the Azure Key Vault Certificate object generated from the provided PFX certificate. | string | n/a | yes |
| cluster\_api\_endpoint | URI to the cluster api | string | n/a | yes |
| cluster\_endpoint | URI to the cluster | string | n/a | yes |
| distribution | Type of linux distribution to use. (ubuntu or rhel) | string | n/a | yes |
| encryption\_password | The password for data encryption in non-external services modes. | string | n/a | yes |
| http\_proxy\_url | HTTP(S) Proxy URL | string | n/a | yes |
| iact | Expects keys: [subnet_list, subnet_time_limit] | map | n/a | yes |
| import\_key | An additional ssh pub key to import to all machines | string | n/a | yes |
| installer\_url | URL to the cluster installer tool | string | n/a | yes |
| license\_file | Path to license file for the application | string | n/a | yes |
| postgresql | Expects keys: [user, password, address, database, extra_params] | map | n/a | yes |
| primary\_count | The count of primary instances being created. | string | n/a | yes |
| release\_sequence | The sequence ID for the Terraform Enterprise version to pin the cluster to. | string | n/a | yes |
| repl\_cidr | custom replicated service CIDR range | string | n/a | yes |
| weave\_cidr | custom weave CIDR range | string | n/a | yes |
| ca_bundle_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections| string | `"none"` | no |

## Outputs

| Name | Description |
|------|-------------|
| console\_password | The generated password for the admin console. |
| primary\_cloud\_init\_list | List of rendered cloud-init templates to pass to primary instances. |
| secondary\_cloud\_init | Rendered cloud-init template to pass to secondary scaling-set. |
