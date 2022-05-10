terraform init -input=false -upgrade \
    -backend-config="resource_group_name=${TF_BACKEND_RG_NAME}" \
    -backend-config="storage_account_name=${TF_BACKEND_STGACCT_NAME}" \
    -backend-config="container_name=${TF_BACKEND_CONTAINER_NAME}" \
    -backend-config="key=${TF_BACKEND_KEY}"