#!/bin/bash

ARM_TENANT_ID="8684e851-0a99-42e3-910b-923b014a2c6e"
ARM_SUBSCRIPTION_ID="9e2b64f2-3f0a-456b-b579-21e8a4cd46b2"
RESOURCE_GROUP_LOCATION="swedencentral"
UNIQUE_MD5=$(md5 -q -s "$ARM_TENANT_ID$ARM_SUBSCRIPTION_ID$RESOURCE_GROUP_NAME$RESOURCE_GROUP_LOCATION")
PREFIX=${UNIQUE_MD5:0:5}

environments=("dev" "test" "prd")
for i in ${environments[@]};
do
    RESOURCE_GROUP_NAME="rg-${i}-tf-release-swc"
    az group create -l $RESOURCE_GROUP_LOCATION -n $RESOURCE_GROUP_NAME --subscription $ARM_SUBSCRIPTION_ID
    STORAGE_ACCOUNT_NAME="${PREFIX}${i}tfstateswc"
    az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME --sku Premium_LRS --kind BlockBlobStorage --subscription $ARM_SUBSCRIPTION_ID
    az storage container create -n tfstate --account-name $STORAGE_ACCOUNT_NAME --subscription $ARM_SUBSCRIPTION_ID
done
