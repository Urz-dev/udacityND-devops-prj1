# Udacity Azure Devops Project 1 - Deploying a webserver in Azure

The contents of this repo are part of the first project for the Azure devops nano degree program.
### Project Goal ###
A webserver deployed on an azure vm using infrastructure-as-code tools, terraform and packer. Additionally, an azure policy to enforce tags on built resources should be created and assigned 

## Azure Account ##
An azure account subscription id is required to make the scripts in this repo work.

## Azure Policy ##
Create a policy that ensures all indexed resources in your subscription have tags and deny deployment if they do not.
A policy template from [Azure Examples](https://github.com/Azure/Community-Policy/tree/master/Policies) is used. 
Policy mode Indexed, so the policy is only applied to resources that can be tagged.
Below are the commands used to define and assign the policy. 
```sh
az policy definition create --name 'tagging-policy' --display-name 'tagging-policy:Deny untagged resources' --description 'Create a policy that ensures all indexed resources in a subscription have tags and deny deployment if they do not' --rules './require-tag-all-resources/azurepolicy.rules.json --mode indexed

az policy assignment create --name 'tagging-policy' --scope /subscriptions/<id>/resourceGroups/Azuredevops --policy /subscriptions/<id>/providers/Microsoft.Authorization/policyDefinitions/tagging-policy

```

## Packer ##

## Terraform ##



