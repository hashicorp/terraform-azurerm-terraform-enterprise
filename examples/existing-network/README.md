# EXAMPLE: Active-Active, External Services Installation of Terraform Enterprise into an Existing Network

## About This Example

This example for Terraform Enterprise creates a TFE installation with the following traits:

- [Active/Active](https://www.terraform.io/enterprise/install/automated/active-active) architecture
- External Services production type
- Standard_D4_v3 virtual machine type
- Ubuntu 24.04
- A publicly accessible HTTP load balancer with TLS termination

## Prerequisites

This example assumes that the following resources exist:

- TFE license is on a file path defined by `var.license_file`
- A DNS zone
- Valid managed SSL certificate to use with load balancer:
  - An Azure Key Vault in which the following are stored:
    - TFE CA certificate (certificate)
    - Key Vault secret which contains the Base64 encoded version of a PEM encoded public certificate for the Virtual Machine Scale Set
    - Key Vault secret which contains the Base64 encoded version of a PEM encoded private key for the Virtual Machine Scale Set.
- Existing Virtual Network (VNET)

## How to Use This Module

### Deployment

1. Read the entire [README.md](../../README.md) of the root module.
2. Ensure account meets module prerequisites from above.
3. Clone repository.
4. Change directory into desired example folder.
5. Create a local `terraform.auto.tfvars` file and instantiate the required inputs as required in the respective `./examples/existing-network/variables.tf` including the path to the license under the `license_file` variable value.
6. Authenticate against the AzureRM provider. See [instructions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli).
7. Initialize terraform and apply the module configurations using the commands below:

  NOTE: `terraform plan` will print out the execution plan which describes the actions Terraform will take in order to build your infrastructure to match the module configuration. If anything in the plan seems incorrect or dangerous, it is safe to abort here and not proceed to `terraform apply`.

  ```
  terraform init
  terraform plan
  terraform apply
  ```

## Post-deployment Tasks

The build should take approximately 10-15 minutes to deploy. Once the module has completed, give the platform another 10 minutes or so prior to attempting to interact with it in order for all containers to start up.

Unless amended, this example will not create an initial admin user using the IACT, but it does output the URL for your convenience. Follow the advice in this document to create the initial admin user, and log into the system using this user in order to configure it for use.

### Connecting to the TFE Application

1. Navigate to the URL supplied via the `login_url` Terraform output. (It may take several minutes for this to be available after initial deployment. You may monitor the progress of cloud init if desired on one of the instances.)
2. Enter a `username`, `email`, and `password` for the initial user.
3. Click `Create an account`.
4. After the initial user is created you may access the TFE Application normally using the URL supplied via `login_url` Terraform output.
