# Mock resources for existing_network example

The Terraform configuration in this directory may be used to create mock resources for testing purposes.

The example commands below supply values on the command line for simplicity. You may alternatively use your own preferred methods. Related documentation is available here: [https://www.terraform.io/docs/language/values/variables.html](https://www.terraform.io/docs/language/values/variables.html).

To create the mock resources *in addition to a new resouce group* and *accept default values* you may run the following commands:
- `terraform init`
- `terraform apply`

To create the mock resources *in addition to a new resource group* while supplying a friendly name for your resources, you may run the following command replacing 'yourvalue' with a desired string value:
- `terraform init`
- `terraform apply -var="friendly_name_prefix"="yourvalue"`

To create the mock resources *in an **existing** resource group* while supplying a friendly name for your resources, you may run the following command replacing 'yourvalue' with a desired string value:
- `terraform init`
- `terraform apply -var="resource_group_name"="yourvalue" -var="friendly_name_prefix"="yourvalue"`
