# Terraform Enterprise: Clustering

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

