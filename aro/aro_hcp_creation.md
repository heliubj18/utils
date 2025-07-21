#!/bin/sh

AZURE_CREDS=/Users/$USER/.azure/credentials
EXTERNAL_DNS_CREDS=/Users/$USER/.azure/external_dns_app
SUBSCRIPTION_ID=$(cat $AZURE_CREDS | jq -r '.subscriptionId')
TENANT_ID=$(cat $AZURE_CREDS | jq -r '.tenantId')
CLIENT_ID=$(cat $AZURE_CREDS | jq -r '.clientId')
CLIENT_SECRET=$(cat $AZURE_CREDS | jq -r '.clientSecret')
AZ_USER=$(az account list --query "[].user.name" -otsv)
OBJECT_ID=$(az ad user list --filter "mail eq '$AZ_USER'" --query "[].id" -o tsv)

PREFIX="heli-az-test-${RANDOM}"
LOCATION="eastus"



AKS_RG=${PREFIX}"-aks-rg"
AKS_CLUSTER_NAME=${PREFIX}"-aks-cluster"
AKS_CP_MI_NAME=${PREFIX}"-aks-cluster-mi"
AKS_KUBELET_MI_NAME=${PREFIX}"-aks-cluster-kubelet-mi"
KV_NAME=${PREFIX}"-kv"


ACR_NAME="heliacr"
ACR_RG=${PREFIX}"-acr-rg"


PARENT_DNS_RG="os4-common"
PARENT_DNS_ZONE="qe.azure.devcluster.openshift.com"

BASE_DOMAIN="qe.azure.devcluster.openshift.com"
DNS_ZONE_NAME="qe1.azure.devcluster.openshift.com"
DNS_ZONE_RG="os4-common"


CLOUD_PROVIDER_SP_NAME=${PREFIX}"-cloud-provider-sp"
CONTROL_PLANE_SP_NAME=${PREFIX}"-cpo-sp"
AZURE_DISK_SP_NAME=${PREFIX}"-azure-disk-sp"
AZURE_FILE_SP_NAME=${PREFIX}"-azure-file-sp"
IMAGE_REGISTRY_SP_NAME=${PREFIX}"-ciro-sp"
INGRESS_SP_NAME=${PREFIX}"-ingress-sp"
CNCC_SP_NAME=${PREFIX}"-cncc-sp"
NODEPOOL_MGMT_SP_NAME=${PREFIX}"-nodepool-mgmt-sp"
KMS_SP_NAME=${PREFIX}"-kms-sp"

CP_OUTPUT_FILE="/Users/$USER/sp-hcp-components.json"

WORKLOAD_IDENTITY_RG="${PREFIX}-workload-identity-rg"
AZURE_DISK_MI_NAME="${PREFIX}-azure-disk-dp-mi"
AZURE_FILE_MI_NAME=${PREFIX}-azure-file-dp-mi
IMAGE_REGISTRY_MI_NAME=${PREFIX}-image-registry-dp-mi

DP_OUTPUT_FILE="/Users/$USER/sp-hc-components.json"


PULL_SECRET=$HOME/pull-secret
HC_NAME="heli-test"

MANAGED_RG_NAME=${HC_NAME}"-hc-rg"
VNET_RG_NAME=${HC_NAME}"-vnet-rg"
NSG_RG_NAME=${HC_NAME}"-nsg-rg"

NSG_NAME=${HC_NAME}"-nsg"
VNET_NAME=${HC_NAME}"-vnet"
SUBNET_NAME=${HC_NAME}"-subnet"

RELEASE_IMAGE="registry.ci.openshift.org/ocp/release:4.19.0-0.nightly-2025-03-21-030708"


#Step 3: Create an azure container registry (acr)
az group create --name ${ACR_RG} --location ${LOCATION}

# Create a ACR
az acr create --name ${ACR_NAME} --resource-group ${ACR_RG} --sku basic


#Step 4: Create a AKS cluster with keyvault secret provider and acr
az group create \
--name ${AKS_RG} \
--location ${LOCATION}

# Create aks control plane's identity
az identity create --name $AKS_CP_MI_NAME --resource-group $AKS_RG
export AKS_CP_MI_ID=$(az identity show --name $AKS_CP_MI_NAME --resource-group $AKS_RG --query id -o tsv)

# Create aks managed identity specific to the kubelet
az identity create --name $AKS_KUBELET_MI_NAME --resource-group $AKS_RG
export AKS_KUBELET_MI_ID=$(az identity show --name $AKS_KUBELET_MI_NAME --resource-group $AKS_RG --query id -o tsv)

# Create a aks cluster with keyvault secrets provider and assocated with a acr
az aks create \
    --resource-group $AKS_RG \
    --name $AKS_CLUSTER_NAME \
    --node-count 3 \
    --generate-ssh-keys \
    --load-balancer-sku standard \
    --os-sku AzureLinux \
    --node-vm-size Standard_D4s_v4 \
    --enable-addons azure-keyvault-secrets-provider \
    --enable-fips-image \
    --enable-cluster-autoscaler \
    --min-count 2 \
    --max-count 6 \
    --enable-secret-rotation \
    --rotation-poll-interval 1m \
    --kubernetes-version 1.31.1 \
    --assign-identity $AKS_CP_MI_ID \
    --assign-kubelet-identity $AKS_KUBELET_MI_ID \
    --attach-acr ${ACR_NAME}

#Step 5: Create a key vault

# Create a keyvault
az keyvault create \
--name ${KV_NAME} \
--resource-group ${AKS_RG} \
--location ${LOCATION} \
--enable-rbac-authorization

# client id of keyvault secret store provider on aks
AZURE_KEY_VAULT_AUTHORIZED_USER_ID=$(az aks show -n ${AKS_CLUSTER_NAME} -g ${AKS_RG} | jq .addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -r)

# object id of keyvault secret store provider on aks
AZURE_KEY_VAULT_AUTHORIZED_OBJECT_ID=$(az aks show -n ${AKS_CLUSTER_NAME} -g ${AKS_RG} | jq .addonProfiles.azureKeyvaultSecretsProvider.identity.objectId -r)

# assign role to the keyvault secret provider object id
az role assignment create \
--assignee-object-id "${AZURE_KEY_VAULT_AUTHORIZED_OBJECT_ID}" \
--role "Key Vault Secrets User" \
--scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/"${AKS_RG}" \
--assignee-principal-type ServicePrincipal

# associate role to YOUR SP/Object ID with the keyvault; this is so you can use your SP with the CLI to create certificates in the key vault
az role assignment create \
    --assignee ${OBJECT_ID} \
    --scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/"${AKS_RG}"/providers/Microsoft.KeyVault/vaults/${KV_NAME} \
    --role "Key Vault Administrator"


#Step 6: Get AKS kubeconfig access

az aks get-credentials \
--resource-group ${AKS_RG} \
--name ${AKS_CLUSTER_NAME} \
--overwrite-existing


#Step 7: Create service principals for control plane components

 cloudProvider=$(az ad sp create-for-rbac --name "${CLOUD_PROVIDER_SP_NAME}" --create-cert --cert "${CLOUD_PROVIDER_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${CLOUD_PROVIDER_SP_NAME}'}" -o json)

 controlPlaneOperator=$(az ad sp create-for-rbac --name "${CONTROL_PLANE_SP_NAME}" --create-cert --cert "${CONTROL_PLANE_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${CONTROL_PLANE_SP_NAME}'}" -o json)

 disk=$(az ad sp create-for-rbac --name "${AZURE_DISK_SP_NAME}" --create-cert --cert "${AZURE_DISK_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${AZURE_DISK_SP_NAME}'}" -o json)

 file=$(az ad sp create-for-rbac --name "${AZURE_FILE_SP_NAME}" --create-cert --cert "${AZURE_FILE_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${AZURE_FILE_SP_NAME}'}" -o json)

 imageRegistry=$(az ad sp create-for-rbac --name "${IMAGE_REGISTRY_SP_NAME}" --create-cert --cert "${IMAGE_REGISTRY_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${IMAGE_REGISTRY_SP_NAME}'}" -o json)

 ingress=$(az ad sp create-for-rbac --name "${INGRESS_SP_NAME}" --create-cert --cert "${INGRESS_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${INGRESS_SP_NAME}'}" -o json)

 network=$(az ad sp create-for-rbac --name "${CNCC_SP_NAME}" --create-cert --cert "${CNCC_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${CNCC_SP_NAME}'}" -o json)

 nodePoolMgmt=$(az ad sp create-for-rbac --name "${NODEPOOL_MGMT_SP_NAME}" --create-cert --cert "${NODEPOOL_MGMT_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${NODEPOOL_MGMT_SP_NAME}'}" -o json)

 kms=$(az ad sp create-for-rbac --name "${KMS_SP_NAME}" --create-cert --cert "${KMS_SP_NAME}" --keyvault "${KV_NAME}" --query "{clientID: appId, certificateName: '${KMS_SP_NAME}'}" -o json)

# assign ingress the contributor role for qe domain
ingress_id=$(echo $ingress | jq -r .clientID)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
BASE_DOMAIN_RESOURCE_GROUP=os4-common
az role assignment create \
  --assignee "${ingress_id}"\
  --role "Contributor" \
  --scope  /subscriptions/"$SUBSCRIPTION_ID"/resourceGroups/"$BASE_DOMAIN_RESOURCE_GROUP"

#qe.azure.devcluster.openshift.com
#qe1.azure.devcluster.openshift.com

oc create secret generic azure-config-file -n default --from-file $EXTERNAL_DNS_CREDS
oc get secret azure-config-file -n default
#NAME                TYPE     DATA   AGE
#azure-config-file   Opaque   1      3h26m

hypershift install \
      --enable-conversion-webhook=false \
      --external-dns-provider=azure \
      --external-dns-credentials=$EXTERNAL_DNS_CREDS  \
      --pull-secret $PULL_SECRET \
      --external-dns-domain-filter $DNS_ZONE_NAME \
      --managed-service ARO-HCP \
      --aro-hcp-key-vault-users-client-id $AZURE_KEY_VAULT_AUTHORIZED_USER_ID \
      --tech-preview-no-upgrade

#Step 14: Create workload identities
