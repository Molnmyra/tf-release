# Bootstrap Terraform for Github and Azure

## Prerequisites

* Azure AD
* Azure Subcription
* Github Repo

## Resource ouput

* Github repo environments
* Github repo secrets and environment secrets
* Azure AD service principals with reader access per environment ({env}-plan)
* Azure AD service principals with owner access per environment ({env}-apply)
* Azure resource group and storage account for terraform state per environment
* Azure resource group as base for each (github) environment

## Configuration

Create `terraform.tfvars` and add the following:

```
tenant_id           = "<azure tenant id>"
subscription_id     = "<azure subscription id>"
github_organization = "<github organization name>"
github_token        = "<github pat with full permissions on github_repo>"
github_repo         = "<github repo to use>"
```
