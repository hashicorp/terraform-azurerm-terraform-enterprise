# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dns | Expects key: [rg_name] | map | n/a | yes |
| install\_id | A prefix to use for resource names | string | n/a | yes |
| key\_size | Byte size for the key-pair used to generate the provided certificate | string | n/a | yes |
| key\_type | Type of key-pair used to generate the provided certificate | string | n/a | yes |
| key\_vault | Expects keys: [name, rg_name] (key_vault name and Azure resource group that key vault resides in.) | map | n/a | yes |
| resource\_prefix | Prefix name for resources | string | n/a | yes |
| rg\_name | The Azure Resource Group to build into | string | n/a | yes |
| subnet\_name | The Azure Virtual Network Subnet to build into | string | n/a | yes |
| tls | Expects keys: [pfx_cert, pfx_cert_pw] (the path to a pfx certificate for the dns zone, the password for that certificate) | map | n/a | yes |
| vnet\_name | The Azure Virtual Network to build into | string | n/a | yes |

