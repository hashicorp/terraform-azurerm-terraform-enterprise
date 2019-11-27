# Terraform Enterprise: Clustering

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain | An Azure hosted DNS domain to use for DNS records | string | n/a | yes |
| key\_vault\_name | The name of an existing key vault to use for certificate generation. | string | n/a | yes |
| license\_file | Path to the Replicated license file. | string | n/a | yes |
| resource\_group\_name | An existing Azure Resource Group to deploy into. | string | n/a | yes |
| subnet | An existing Azure Subnet to deploy into | string | n/a | yes |
| tls\_pfx\_certificate | The path to a PFX certificate for front end SSL communication. | string | n/a | yes |
| tls\_pfx\_certificate\_password | The password for the associated SSL certificate. | string | n/a | yes |
| virtual\_network\_name | An existing Azure Virtual Network to deploy into | string | n/a | yes |
| airgap\_installer\_url | URL to replicated's airgap installer package | string | `"https://install.terraform.io/installer/replicated-v5.tar.gz"` | no |
| airgap\_mode\_enable | install in airgap mode | string | `"False"` | no |
| airgap\_package\_url | Signed URL to download the package | string | `""` | no |
| azure\_es\_account\_key | The Azure account key for external services | string | `""` | no |
| azure\_es\_account\_name | The Azure account name for external services | string | `""` | no |
| azure\_es\_container | The Azure container for external services | string | `""` | no |
| ca\_bundle\_url | URL to Custom CA bundle used for outgoing connections | string | `""` | no |
| distribution | Type of linux distribution to use. (ubuntu or rhel) | string | `"ubuntu"` | no |
| dns\_ttl | The TTL for dns records. | string | `"120"` | no |
| domain\_resource\_group\_name | The name of the resource group where the domain name resides, if not set the main resource group will be used. | string | `""` | no |
| encryption\_password | The password for data encryption in non-external services modes. | string | `""` | no |
| http\_proxy\_url | HTTP(S) Proxy URL | string | `""` | no |
| iact\_subnet\_list | IP Cidr Mask to allow to access Initial Admin Creation Token (IACT) API. [Terraform Docs](https://www.terraform.io/docs/enterprise/private/automating-initial-user.html) | string | `""` | no |
| iact\_subnet\_time\_limit | Amount of time to allow access to IACT API after initial boot | string | `""` | no |
| import\_key | An additional ssh pub key to import to all machines | string | `""` | no |
| installer\_url | URL to the cluster setup tool | string | `"https://install.terraform.io/installer/ptfe-0.1.zip"` | no |
| key\_vault\_resource\_group\_name | The existing Azure Resource Group where the key vault is stored, defaults to the main resource group if not set. | string | `""` | no |
| os\_disk\_size | The size in Gb for the OS disk of the primary seed virtual machine | string | `"100"` | no |
| postgresql\_address | address to connect to external postgresql database at | string | `""` | no |
| postgresql\_database | database name to use in exetrnal postgresql database | string | `""` | no |
| postgresql\_extra\_params | additional connection string parameters (must be url query params) | string | `""` | no |
| postgresql\_password | password to connect to external postgresql database as | string | `""` | no |
| postgresql\_user | user to connect to external postgresql database as | string | `""` | no |
| primary\_vm\_size | The Azure VM Size to use. | string | `"Standard_D4s_v3"` | no |
| release\_sequence | The sequence ID for the Terraform Enterprise version to pin the cluster to. | string | `"latest"` | no |
| repl\_cidr | Specify a non-standard CIDR range for the replicated services. The default is 10.96.0.0/12 | string | `""` | no |
| resource\_prefix | Prefix name for resources created by this module | string | `"tfe"` | no |
| secondary\_count | The number of secondary virtual machines to create. | string | `"5"` | no |
| secondary\_vm\_size | The Azure VM Size to use (will use primary_vm_size if not set). | string | `""` | no |
| ssh\_user | The ssh user to create | string | `"ubuntu"` | no |
| storage\_image | A list of the data to define the os version image to build from | map | `{ "offer": "UbuntuServer", "publisher": "Canonical", "sku": "16.04-LTS", "version": "latest" }` | no |
| tls\_pfx\_certificate\_key\_size | The size of the Key used in the Certificate. Possible values include 2048 and 4096. | string | `"2048"` | no |
| tls\_pfx\_certificate\_key\_type | Specifies the Type of Key, such as RSA. | string | `"RSA"` | no |
| vm\_size\_tier | The tier for the vms (must be 'Standard' or 'Basic') and must match with vm_size | string | `"Standard"` | no |
| weave\_cidr | Specify a non-standard CIDR range for weave. The default is 10.32.0.0/12 | string | `""` | no |

