# Terraform Enterprise: High Availability - cluster_lb submodule


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dns | Expects keys: [domain, rg_name, ttl] | map | n/a | yes |
| install\_id | A prefix to use for resource names | string | n/a | yes |
| lb\_port | Expects map with format `name: [frontend_port, protocol, backend_port]` for all routes. | map | n/a | yes |
| location | The Azure Location to build into | string | n/a | yes |
| rg\_name | The Azure Resource Group to build into | string | n/a | yes |
| lb\_probe\_interval | The interval for the Loadbalancer healthcheck probe. | string | `"10"` | no |
| lb\_probe\_unhealthy\_threshold | The amount of unhealthy checks before marking a node unhealthy. | string | `"2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_endpoint\_dns | The dns endpoint for this loadbalancer |
| backend\_pool\_id | The id of the backend pool for this loadbalancer. |
| lb\_endpoint\_dns | The api dns endpoint for this loadbalancer |
| public\_ip\_address | The public ip address of this loadbalancer |
| public\_ip\_id | The id of the public ip resource in Azure of this loadbalancer |

