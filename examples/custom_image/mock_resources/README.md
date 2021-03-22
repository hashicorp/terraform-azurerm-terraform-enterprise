# Create a custom image in Azure using Packer

Refer to this Microsoft article for more information: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer

`az group create -n somerg -l eastus`  
`az account show --query "{ subscription_id: id }"`  
`az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

Modify values in example.json for the following variables from output above:

`client_id`  
`client_secret`  
`tenant_id`  
`subscription_id`  

Build image using packer:

`packer build ./example.json`
