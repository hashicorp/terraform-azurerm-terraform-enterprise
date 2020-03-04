# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloud\_init\_data | Rendered cloud-init template to pass to the vms. | `string` | n/a | yes |
| install\_id | A prefix to use for resource names | `string` | n/a | yes |
| location | The Azure Location to build into | `string` | n/a | yes |
| resource\_prefix | Prefix name for resources | `string` | n/a | yes |
| rg\_name | The Azure Resource Group to build into | `string` | n/a | yes |
| ssh\_public\_key | The ssh public key to give to all vms in the scale-set for the local administrator account. | `string` | n/a | yes |
| storage\_image | Expects keys: [publisher, offer, sku, version] | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | n/a | yes |
| subnet\_id | The Azure Subnet to build into | `string` | n/a | yes |
| username | Specifies the name of the local administrator account. | `string` | n/a | yes |
| vm | Expects keys: [size, count, size\_tier] | <pre>object({<br>    count     = number<br>    size      = string<br>    size_tier = string<br>  })</pre> | n/a | yes |
| additional\_tags | A map of additional tags to attach to all resources created. | `map` | `{}` | no |

