# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| install\_id | A prefix to use for resource names | `string` | n/a | yes |
| key\_size | Byte size for the key-pair used to generate the provided certificate | `string` | n/a | yes |
| key\_type | Type of key-pair used to generate the provided certificate | `string` | n/a | yes |
| key\_vault | Expects keys: [name, rg\_name] (key\_vault name and Azure resource group that key vault resides in.) | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | n/a | yes |
| resource\_prefix | Prefix name for resources | `string` | n/a | yes |
| rg\_name | The Azure Resource Group to build into | `string` | n/a | yes |
| subnet\_name | The Azure Virtual Network Subnet to build into | `string` | n/a | yes |
| tls | Expects keys: [pfx\_cert, pfx\_cert\_pw] (the path to a pfx certificate for the dns zone, the password for that certificate) | <pre>object({<br>    pfx_cert    = string<br>    pfx_cert_pw = string<br>  })</pre> | n/a | yes |
| vnet | Expects keys: [name, rg\_name] (The Azure Virtual Network to build into and the resource group of the Virtual Network | <pre>object({<br>    name    = string<br>    rg_name = string<br>  })</pre> | n/a | yes |
| additional\_tags | A map of additional tags to attach to all resources created. | `map` | `{}` | no |
| domain\_rg\_name | Resource group of the DNS zone | `string` | `""` | no |

