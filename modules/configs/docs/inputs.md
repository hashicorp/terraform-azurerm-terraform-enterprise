# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| airgap | Expects keys: [enable, package\_url, installer\_url] | <pre>object({<br>    enable        = bool<br>    package_url   = string<br>    installer_url = string<br>  })</pre> | n/a | yes |
| assistant\_port | Port the assitant sidecar-like node service is running on. | `any` | n/a | yes |
| azure\_es | Expects keys: [enable, account\_name, account\_key, container, endpoint] | <pre>object({<br>    enable       = bool<br>    account_name = string<br>    account_key  = string<br>    container    = string<br>    endpoint     = string<br>  })</pre> | n/a | yes |
| ca\_bundle\_url | URL to CA certificate file used for the internal `ptfe-proxy` used for outgoing connections | `string` | n/a | yes |
| cert\_thumbprint | The thumbprint for the Azure Key Vault Certificate object generated from the provided PFX certificate. | `string` | n/a | yes |
| cluster\_api\_endpoint | URI to the cluster api | `string` | n/a | yes |
| cluster\_endpoint | URI to the cluster | `string` | n/a | yes |
| cluster\_hostname | The hostname of the TFE application. Example: tfe.company.com | `string` | n/a | yes |
| distribution | Type of linux distribution to use. (ubuntu or rhel) | `string` | n/a | yes |
| encryption\_password | The password for data encryption in non-external services modes. | `string` | n/a | yes |
| http\_proxy\_url | HTTP(S) Proxy URL | `string` | n/a | yes |
| iact | Expects keys: [subnet\_list, subnet\_time\_limit] | <pre>object({<br>    subnet_list       = list(string)<br>    subnet_time_limit = string<br>  })</pre> | n/a | yes |
| import\_key | An additional ssh pub key to import to all machines | `string` | n/a | yes |
| installer\_url | URL to the cluster installer tool | `string` | n/a | yes |
| license\_file | Path to license file for the application | `string` | n/a | yes |
| postgresql | Expects keys: [user, password, address, database, extra\_params] | <pre>object({<br>    user         = string<br>    password     = string<br>    address      = string<br>    database     = string<br>    extra_params = string<br>  })</pre> | n/a | yes |
| primary\_count | The count of primary instances being created. | `number` | n/a | yes |
| release\_sequence | The sequence ID for the Terraform Enterprise version to pin the cluster to. | `string` | n/a | yes |
| repl\_cidr | custom replicated service CIDR range | `string` | n/a | yes |
| weave\_cidr | custom weave CIDR range | `string` | n/a | yes |
| additional\_no\_proxy | Comma delimitted list of addresses (no spaces) to not use the proxy for | `string` | `""` | no |
| additional\_tags | A map of additional tags to attach to all resources created. | `map` | `{}` | no |
