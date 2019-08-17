# Terraform Enterprise: High Availability - Azure Module

![Terraform Enterprise Logo](assets/Terraform_Enterprise_PrimaryLogo.png)

## Description

This module creates the infrastructure for a clustered version of Terraform Enterprise.
This work is in Beta and should be treated as such.

Please contact your Technical Account Manager for more information, and support for any issues you have.

## Architecture

---

<p align="center">
  <img src="assets/azure_diagram.png" alt="Diagram of 3 tier clustered application with a loadbalancer, 3 primary vms, and a scaleset of secondary vms, with adjacent key vault for tls">
</p>

---

## Examples

Please see the examples directory for more extensive examples.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application\_subnet\_name | An existing Azure Subnet to deploy into | string | n/a | yes |
| distribution | Type of linux distribution to use. (ubuntu or rhel) | string | n/a | yes |
| domain | An Azure hosted DNS domain to use for DNS records | string | n/a | yes |
| key\_vault\_name | The name of an existing key vault to use for certificate generation. | string | n/a | yes |
| license\_file | Path to the Replicated license file. | string | n/a | yes |
| primary\_count | The number of primary virtual machines to create. | string | n/a | yes |
| resource\_group\_name | An existing Azure Resource Group to deploy into. | string | n/a | yes |
| secondary\_count | The number of secondary virtual machines to create. | string | n/a | yes |
| tls\_pfx\_certificate | The path to a PFX certificate for front end SSL communication. | string | n/a | yes |
| tls\_pfx\_certificate\_password | The password for the associated SSL certificate. | string | n/a | yes |
| virtual\_network\_name | An existing Azure Virtual Network to deploy into | string | n/a | yes |
| airgap\_installer\_url | URL to replicated's airgap installer package | string | `"https://install.terraform.io/installer/replicated-v5.tar.gz"` | no |
| airgap\_mode\_enable | install in airgap mode | string | `"False"` | no |
| airgap\_package\_url | Signed URL to download the package | string | `""` | no |
| azure\_es\_account\_key | The Azure account key for external services | string | `""` | no |
| azure\_es\_account\_name | The Azure account name for external services | string | `""` | no |
| azure\_es\_container | The Azure container for external services | string | `""` | no |
| default\_username | The default user to use | string | `"ubuntu"` | no |
| dns\_ttl | The TTL for dns records. | string | `"120"` | no |
| domain\_resource\_group\_name | The name of the resource group where the domain name resides, if not set the main resource group will be used. | string | `""` | no |
| encryption\_password | The password for data encryption in non-external services modes. | string | `""` | no |
| external\_services | mode to install ('True' or 'False') | string | `"False"` | no |
| http\_proxy\_url | HTTP(S) Proxy URL | string | `""` | no |
| iact\_subnet\_list | IP Cidr Mask to allow to access Initial Admin Creation Token (IACT) API. [Terraform Docs](https://www.terraform.io/docs/enterprise/private/automating-initial-user.html) | string | `""` | no |
| iact\_subnet\_time\_limit | Amount of time to allow access to IACT API after initial boot | string | `""` | no |
| import\_key | An additional ssh pub key to import to all machines | string | `""` | no |
| installer\_tool\_url | URL to the cluster installer tool | string | `"https://install.terraform.io/installer/ptfe.zip"` | no |
| key\_vault\_resource\_group\_name | The existing Azure Resource Group where the key vault is stored, defaults to the main resource group if not set. | string | `""` | no |
| os\_disk\_size | The size in Gb for the OS disk of the primary seed virtual machine | string | `"100"` | no |
| postgresql\_address | address to connect to external postgresql database at | string | `""` | no |
| postgresql\_database | database name to use in exetrnal postgresql database | string | `""` | no |
| postgresql\_extra\_params | additional connection string parameters (must be url query params) | string | `""` | no |
| postgresql\_password | password to connect to external postgresql database as | string | `""` | no |
| postgresql\_user | user to connect to external postgresql database as | string | `""` | no |
| primary\_vm\_size | The Azure VM Size to use. | string | `"Standard_D4s_v3"` | no |
| secondary\_vm\_size | The Azure VM Size to use (will use primary_vm_size if not set). | string | `""` | no |
| storage\_image | A list of the data to define the os version image to build from | map | `{ "offer": "UbuntuServer", "publisher": "Canonical", "sku": "18.04-LTS", "version": "latest" }` | no |
| vm\_size\_tier | The tier for the vms (must be 'Standard' or 'Basic') and must match with vm_size | string | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_console\_password | Generated password to unlock the admin console. |
| application\_endpoint | The URI for accessing the application. |
| console\_endpoint | The URI for accessing the backend console. |
| health\_check\_endpoint | The URI for the application health checks. |
| install\_id | The string prefix for resources. |
| primary\_public\_ip | The public IP address of the first primary node created. |
| ssh\_config\_file | Path to ssh_config file for command: `ssh -F $(terraform state show <terraform_parent_modules>.module.<module_name>.module.primaries.local_file.ssh_config | grep filename | awk '{print $3}') default` |
| ssh\_private\_key | Path to the private key used for ssh authorization. |
