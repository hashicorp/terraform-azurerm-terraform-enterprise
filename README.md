# Terraform Enterprise: Clustering - Azure Module

![Terraform Enterprise Logo](https://github.com/hashicorp/terraform-azurerm-terraform-enterprise/blob/master/assets/Terraform_Enterprise_PrimaryLogo.png?raw=true)

## Description

This module creates the infrastructure for a clustered version of Terraform Enterprise.
This work is in Beta and should be treated as such.

Please contact your Technical Account Manager for more information, and support for any issues you have.

## Architecture

---

<p align="center">
  <img src="https://github.com/hashicorp/terraform-azurerm-terraform-enterprise/blob/v0.0.1-beta/assets/azure_diagram.png?raw=true" alt="Diagram of 3 tier clustered application with a loadbalancer, 3 primary vms, and a scaleset of secondary vms, with adjacent key vault for tls">
</p>

---

## Network Configuration

These modules presume there is an existing Virtual Network and Network Security Group to use. The Network Security Group must have at a minimum the following configuration:

* Allow inbound port 6443 between all nodes of the TFE cluster and the load balancer
* Allow inbound port 23010 between all nodes of the TFE cluster and the load balancer
* Allow inbound port 8800 from your operator network (could be the public internet) to allow for access to the operator dashboard
* Allow inbound port 443 to access the TFE application itself

## Examples

Please see the [examples directory](https://github.com/hashicorp/terraform-azurerm-terraform-enterprise/tree/master/examples/) for more extensive examples.

## Inputs

Please see the [inputs documentation](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/azurerm/?tab=inputs)

Repository versions of the inputs documentation can be found in [docs/inputs.md](docs/inputs.md)

## Outputs

Please see the [outputs documentation](https://registry.terraform.io/modules/hashicorp/terraform-enterprise/azurerm/?tab=outputs)

Repository versions of the outputs documentation can be found in [docs/outputs.md](docs/outputs.md)
