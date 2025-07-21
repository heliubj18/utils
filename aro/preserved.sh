RESOURCE_GROUP=preserved-hypershift-ci-rg
KEYVAULT_NAME=preserved-hcp-ci-kv
LOCATION=eastus
az keyvault create -n "$KEYVAULT_NAME" -g "$RESOURCE_GROUP" -l "$LOCATION" --enable-purge-protection --enable-rbac-authorization --retention-days 7