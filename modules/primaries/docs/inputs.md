# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloud\_init\_data\_list | List of rendered cloud-init templates to pass to the vms. | list | n/a | yes |
| cluster\_backend\_pool\_id | The id of the backend pool for the cluster loadbalancer. | string | n/a | yes |
| external\_services | Boolean string for whether or not to install in Internal Production Mode or External Services Mode | string | n/a | yes |
| install\_id | A prefix to use for resource names | string | n/a | yes |
| key\_vault | Expects keys: [id, cert_uri] | map | n/a | yes |
| location | The Azure Location to build into | string | n/a | yes |
| os\_disk\_size | Specifies the size of the OS Disk in gigabytes. | string | n/a | yes |
| resource\_prefix | Prefix name for resources | string | n/a | yes |
| rg\_name | The Azure Resource Group to build into | string | n/a | yes |
| ssh | Expects keys: [public_key, private_key_path] | map | n/a | yes |
| storage\_image | Expects keys: [publisher, offer, sku, version] | map | n/a | yes |
| subnet\_id | The Azure Subnet to build into | string | n/a | yes |
| username | Specifies the name of the local administrator account. | string | n/a | yes |
| vm | Expects keys: [count, size] | map | n/a | yes |

