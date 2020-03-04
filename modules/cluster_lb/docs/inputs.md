# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| dns | Expects keys: [domain, rg\_name, ttl] | <pre>object({<br>    domain  = string<br>    rg_name = string<br>    ttl     = number<br>  })</pre> | n/a | yes |
| install\_id | A prefix to use for resource names | `string` | n/a | yes |
| lb\_port | Expects map with format `name: [frontend_port, protocol, backend_port]` for all routes. | `map(list(string))` | n/a | yes |
| location | The Azure Location to build into | `string` | n/a | yes |
| resource\_prefix | Prefix name for resources | `string` | n/a | yes |
| rg\_name | The Azure Resource Group to build into | `string` | n/a | yes |
| additional\_tags | A map of additional tags to attach to all resources created. | `map` | `{}` | no |
| hostname | hostname for loadbalancer front end to use | `string` | `""` | no |
| lb\_probe\_interval | The interval for the Loadbalancer healthcheck probe. | `number` | `10` | no |
| lb\_probe\_unhealthy\_threshold | The amount of unhealthy checks before marking a node unhealthy. | `number` | `2` | no |

