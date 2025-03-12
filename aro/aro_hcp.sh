#!/bin/sh
set -euo pipefail

RESOURCE_NAME_PREFIX=heli-aks

#aks rg
AKS_RESOURCEGROUP="${RESOURCE_NAME_PREFIX}-aks-rg"
AKS_CLUSTER_NAME=${RESOURCE_NAME_PREFIX}"-aks-cluster"

NAME_OF_PERSONAL_SP=heli-test
PERSONAL_SP_NAME=$NAME_OF_PERSONAL_SP
LOCATION="eastus"
PERSISTENT_RG_NAME="os4-common"
SP_AKS_CREDS=<PATH_TO_AKS_CREDS>
RELEASE_IMAGE=<OCP_PAYLOAD_RELEASE_IMAGE>
AKS_CP_MI_NAME=<MANAGED_IDENTITY_NAME_FOR_AKS_CLUSTER>
AKS_KUBELET_MI_NAME=<KUBELET_MANAGED_IDENTITY_NAME_FOR_AKS_CLUSTER>
KV_NAME=<KV_NAME>
AZURE_DISK_SP_NAME="azure-disk-<PERSONAL_SP_NAME>"
AZURE_FILE_SP_NAME="azure-file-<PERSONAL_SP_NAME>"
NODEPOOL_MGMT="nodepool-mgmt-<PERSONAL_SP_NAME>"
CLOUD_PROVIDER_SP_NAME="cloud-provider-<PERSONAL_SP_NAME>"
CNCC_NAME="cncc-<PERSONAL_SP_NAME>"
CONTROL_PLANE_SP_NAME="cpo-<PERSONAL_SP_NAME>"
IMAGE_REGISTRY_SP_NAME="ciro-<PERSONAL_SP_NAME>"
INGRESS_SP_NAME="ingress-<PERSONAL_SP_NAME>"
CP_OUTPUT_FILE=<output file for control plane service principals>
DP_OUTPUT_FILE=<output file for data plane managed identities>
AKS_CLUSTER_RG_NAME=<AKS_CLUSTER_RG_NAME>
DNS_RECORD_NAME=<DNS_RECORD_NAME>
EXTERNAL_DNS_SP_NAME=<EXTERNAL_DNS_SP_NAME>
EXTERNAL_DNS_CREDS=<PATH_TO_FILE_WITH_DNS_CREDS>
DNS_ZONE_NAME="<DNS_RECORD_NAME>.hypershift.azure.devcluster.openshift.com"
PARENT_DNS_ZONE="hypershift.azure.devcluster.openshift.com"
PARENT_DNS_RG="os4-common"
HC_NAME=<HC_NAME>

PULL_SECRET=$(HOME)/pull-secret


# create aks rg
az group create --name "$AKS_RESOURCEGROUP" --location "$LOCATION"

# create aks
az aks create \
--resource-group ${AKS_RESOURCEGROUP} \
--name ${AKS_CLUSTER_NAME} \
--node-count 3 \
--generate-ssh-keys \
--load-balancer-sku standard \
--os-sku AzureLinux \
--node-vm-size Standard_D4s_v4 \
--enable-fips-image \
--kubernetes-version 1.31.1 \
--enable-addons azure-keyvault-secrets-provider \
--enable-secret-rotation \
--rotation-poll-interval 1m \
--assign-identity ${AKS_MI} \
--assign-kubelet-identity ${AKS_KUBELET_MI}