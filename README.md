# Terraform Enterprise Azure Module

**IMPORTANT**: You are viewing a **beta version** of the official
module to install Terraform Enterprise. This new version is
**incompatible with earlier versions**, and it is not currently meant
for production use. Please contact your Customer Success Manager for
details before using.

This is a Terraform module for provisioning a Terraform Enterprise Cluster on Azure. Terraform Enterprise is our self-hosted distribution of Terraform Cloud. It offers enterprises a private instance of the Terraform Cloud application, with no resource limits and with additional enterprise-grade architectural features like audit logging and SAML single sign-on.

## About This Module

This module will install Terraform Enterprise on Azure according to the [HashiCorp Reference Architecture](https://www.terraform.io/docs/enterprise/before-installing/reference-architecture/azure.html). This module is intended to be used by practitioners seeking a Terraform Enterprise installation which requires minimal configuration in the Azure cloud. 

As the goal for this main module is to provide a drop-in solution for installing Terraform Enterprise via the Golden Path it leverages Azure native solutions such as Azure Database for PostgreSQL and Azure Cache for Redis. We have provided guidance and limited examples for other use cases.

## Pre-requisites

This module is intended to run in an Azure account with minimal preparation, however it does have the following prerequisites:

### Terraform version >= 0.13

* This module requires Terraform version `0.13` or greater to be installed on the running machine.

### License file

* A terraform license file is required and the path to this file must be supplied. An empty placeholder `license.rli` file exists in each example within a `./files` directory and serves as a reference `tfe_license_filepath = "${path.module}/files/license.rli"`.

### Azure Resources

* Resource groups
    * An existing resource group should be supplied for `resource_group_name`. This existing resource group should also contain an existing DNS zone, Key Vault, and Key Vault Certificate unless stated in an example or otherwise required for a particular scenario.

* DNS
    * If you are managing DNS via Azure DNS:
        * Existing resource group with DNS zone should be supplied as `resource_group_name` or, if it exists in another resource group, `resource_group_name_dns`
        * Existing DNS zone should exist matching `domain_name`
        * Desired subdomain should be supplied as `tfe_subdomain`
        * DNS record will be created as `tfe_subdomain`.`domain_name`
    * If you are managing DNS outside of Azure DNS:
        * Module will output resulting load balancer or application gateway IP address as `load_balancer_ip`
        * You must configured external DNS record for the aforementioned IP address

* Key Vault
    * The value supplied for `key_vault_name` should match an existing Key Vault. If not supplied, the module will create and use self signed certificates which is not recommended for production use. If the existing Key Vault does not live in the primary resource group, you may optionally supply a value for `resource_group_name_kv`.

* Certificates
    * The value supplied for `certificate_name` should match an existing Key Vault Certificate residing within the Key Vault specified via `key_vault_name`. If not supplied, the module will create and use self signed certificates which is not recommended for production use.

## Azure Services Used

* Azure Active Directory
* Azure Application Gateway
* Azure Bastion
* Azure Blob Storage
* Azure Cache for Redis
* Azure Database for PostgreSQL
* Azure DNS
* Azure Key Vault
* Azure Load Balancer
* Azure Virtual Machines
* Azure Virtual Network
* Azure Resource Groups

## How to Use This Module

### Deployment

1. Clone repository to local machine
2. Change directory into desired example (such as ./examples/active_active)
3. Replace license file (./files/license.rli) with your own using the same name or modify tfe_license_filepath variable with appropriate local path
4. Authenticate against provider
    * https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli
    * `az login`
    * `az account list`
    * `az account set --subscription="SUBSCRIPTION_ID"`
5. `terraform init`
6. `terraform plan`
7. `terraform apply`

### Connecting to the TFE Server Instance

[Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview) is used in this module to connect to the TFE instance. Additional information on connecting to a Linux instance using SSH through Azure Bastion is available [here](https://docs.microsoft.com/en-us/azure/bastion/bastion-connect-vm-ssh).

1. Follow the steps in the [Deployment](#deployment) section
2. Copy the `instance_user_name` and `instance_private_key` Terraform outputs
3. Open the Azure portal
4. Navigate to the virtual machine instance
5. Click `connect` -> `bastion` -> `use bastion`
6. Enter the `instance_user_name` for `username`
7. Select `SSH Private Key` as the authentication type
8. Enter the `instance_private_key` for `ssh private key`
9. Click `connect`

### Connecting to the TFE Console

The TFE Console is only available in a standalone environment (vm_node_count == 1).

1. Follow the steps in the [Deployment](#deployment) section
2. Navigate to the URL supplied via `tfe_console_url` Terraform output
3. Copy the `tfe_console_password` Terraform output
4. Enter the console password
5. Click `Unlock`

### Connecting to the TFE Application

1. Follow the steps in the [Deployment](#deployment) section
2. Navigate to the URL supplied via `login_url` Terraform output (it may take several minutes for this to be available after initial deployment - you may monitor the progress of cloud init if desired on one of the instances)
3. Enter a `username`, `email`, and `password` for the initial user
4. Click `Create an account`
5. After the initial user is created you may access the TFE Application normally using the URL supplied via `tfe_application_url` Terraform output

## License

This code is released under the Mozilla Public License 2.0. Please see [LICENSE](https://github.com/hashicorp/espd-tfe-azure/blob/master/LICENSE) for more details.
