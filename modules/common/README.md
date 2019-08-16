# Terraform Enterprise: High Availability - common submodule


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dns | Expects key: [rg_name] | map | n/a | yes |
| install\_id | A prefix to use for resource names | string | n/a | yes |
| key\_vault | Expects keys: [name, rg_name] (key_vault name and Azure resource group that key vault resides in.) | map | n/a | yes |
| rg\_name | The Azure Resource Group to build into | string | n/a | yes |
| subnet\_name | The Azure Virtual Network Subnet to build into | string | n/a | yes |
| tls | Expects keys: [pfx_cert, pfx_cert_pw] (the path to a pfx certificate for the dns zone, the password for that certificate) | map | n/a | yes |
| vnet\_name | The Azure Virtual Network to build into | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| app\_subnet\_id | The id of the Subnet within the Azure Virtual Network to use. |
| app\_subnet\_name | The name of the Subnet within the Azure Virtual Network to use. |
| cert\_data | The data of the provided certificate. |
| cert\_pass | The password for the provided certificate |
| cert\_secret\_id | The id of the Azure Key Vault certificate object generated from the provided PFX certificate. |
| cert\_thumbprint | The thumbprint for the Azure Key Vault Certificate object generated from the provided PFX certificate. |
| domain\_rg\_name | The Azure Resource Group the domain/dns zone exists in. |
| rg\_location | The Location the Azure Resource Group is in. |
| rg\_name | The Azure Resource Group to use. |
| ssh\_private\_key\_path | The path to the associated private key file to the public key used for instance login. |
| ssh\_public\_key | The value of the generated ssh public key to use for instance login. |
| vault\_id | The id of the Azure Key Vault to use. |
| vnet\_id | The id of the Azure Virtual Network to use. |
| vnet\_name | The name of the Azure Virtual Network to use. |

