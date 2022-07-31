# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

The contents of this repo are part of the first project for the Azure devops nano degree program.

### Dependencies
1. An [Azure Account](https://portal.azure.com) 
2. [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Image creation with [Packer](https://www.packer.io/downloads)
4. Deployment with [Terraform](https://www.terraform.io/downloads.html)



## Azure Account ##
An azure account subscription id is required to make the scripts in this repo work.

## Azure Policy ##
Create a policy that ensures all indexed resources in your subscription have tags and deny deployment if they do not.
A policy template from [Azure Examples](https://github.com/Azure/Community-Policy/tree/master/Policies) is used. 
Policy mode Indexed, so the policy is only applied to resources that can be tagged.
Below are the commands used to define and assign the policy. 
```sh
az policy definition create --name tagging-policy --display-name 'tagging-policy:Deny untagged resources' --description 'Create a policy that ensures all indexed resources in a subscription have tags and deny deployment if they do not' --rules './require-tag-all-resources/azurepolicy.rules.json --mode indexed

az policy assignment create --name tagging-policy --scope /subscriptions/<id>/resourceGroups/Azuredevops --policy /subscriptions/<id>/providers/Microsoft.Authorization/policyDefinitions/tagging-policy

```

## Packer ##
[server.json](./server.json) file is used to build image of our server virtual machine. To run this file, Azure account details need to be placed in environment variables. Following variables need to set in environment: 
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_SUBSCRIPTION_ID

Image can be build using command:
```sh
packer build server.json
```

## Terraform ##



