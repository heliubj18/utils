#!/bin/sh
set -e

CLUSTER_NAME=${CLUSTER_NAME:-"heli-test-$RANDOM"}
PULL_SSECRET=${PULL_SSECRET:-"$HOME/pull-secret"}
AWS_CREDS=${AWS_CREDS:-"$HOME/.aws/credentials"}
NODEPOOL_REPLICAS=${NODEPOOL_REPLICAS:-"2"}
HYPERSHIFT_AWS_REGION=${HYPERSHIFT_AWS_REGION:-"us-east-2"}
NAMESPACE=${NAMESPACE:-"clusters"}
AWS_EXTERNAL_DNS_DOMAIN=${AWS_EXTERNAL_DNS_DOMAIN:-"hypershift-ext.qe.devcluster.openshift.com"}
AWS_BASE_DOMAIN=${AWS_BASE_DOMAIN:-"qe.devcluster.openshift.com"}

if [ -z "${RELEASE_IMAGE}" ] && [ "${RELEASE_IMAGE_SYNC_MGMT}" == "true" ] ; then
  RELEASE_IMAGE=$(oc get clusterversion version -ojsonpath={.status.desired.image})
fi

HYPERSHIFT_CLI=${HYPERSHIFT_CLI:-"hypershift"}

#--control-plane-availability-policy=HighlyAvailable
create_cmd="${HYPERSHIFT_CLI} create cluster aws \
--name=${CLUSTER_NAME} \
--pull-secret=${PULL_SSECRET} \
--aws-creds=${AWS_CREDS} \
--node-pool-replicas=${NODEPOOL_REPLICAS} \
--region=${HYPERSHIFT_AWS_REGION} \
--base-domain=${AWS_BASE_DOMAIN} \
--annotations=hypershift.openshift.io/cleanup-cloud-resources=\"true\" \
--ssh-key=${HOME}/.ssh/id_rsa.pub "

if [[ -n "${CONTROL_PLANE_OPERATOR}" ]] ; then
   create_cmd=${create_cmd}" --control-plane-operator-image=${CONTROL_PLANE_OPERATOR}"
fi

if [[ -n ${HC_NAMESPACE} ]] ; then
  create_cmd=${create_cmd}" --namespace=${HC_NAMESPACE}"
fi

if [[ "${ENDPOINT_ACCESS}" == "PublicAndPrivate" ]] ||  [[ "${ENDPOINT_ACCESS}" == "Private" ]] ; then
  create_cmd=${create_cmd}" --endpoint-access=${ENDPOINT_ACCESS} --external-dns-domain=${AWS_EXTERNAL_DNS_DOMAIN}"
  if [[ "${ENDPOINT_ACCESS}" == "Private" ]] ; then
    create_cmd=${create_cmd}" --ssh-key=$HOME/.ssh/id_rsa.pub "
  fi
fi

if [[ -n ${INFRA_AVAILABILITY_POLICY} ]] ; then
  create_cmd=${create_cmd}" --infra-availability-policy=${INFRA_AVAILABILITY_POLICY}"
fi

if [[ -n ${CP_AVAILABILITY_POLICY} ]] ; then
  create_cmd=${create_cmd}" --control-plane-availability-policy=${CP_AVAILABILITY_POLICY}"
fi


if [[ -n ${ZONES} ]] ; then
  create_cmd=${create_cmd}" --zones=${ZONES} "
fi

if [[ -n ${HYPERSHIFT_ARCH} ]] ; then
  create_cmd=${create_cmd}" --arch=${HYPERSHIFT_ARCH}"
fi

if [[ -n ${HYPERSHIFT_MULTI_ARCH} ]] ; then
  create_cmd=${create_cmd}" --multi-arch=${HYPERSHIFT_MULTI_ARCH}"
fi

if [[ -n ${RELEASE_IMAGE} ]] ; then
  create_cmd=${create_cmd}" --release-image=${RELEASE_IMAGE}"
fi

if [[ -n ${IMAGE_CONTENT_SOURCES} ]] ; then
  create_cmd=${create_cmd}" --image-content-sources=${IMAGE_CONTENT_SOURCES}"
fi

if [[ "${ENABLE_FIPS}" == "true" ]] ; then
  create_cmd=${create_cmd}" --fips"
fi

if [[ "${DEDICATED}" == "true" ]] ; then
  create_cmd=${create_cmd}" --annotations hypershift.openshift.io/topology=dedicated-request-serving-components"
fi

#if [[ -n ${RENDER} ]] ; then
#  create_cmd=${create_cmd}" --render > hostedcluster.yaml"
#fi

if [[ -n ${NETWORK_TYPE} ]] ; then
  create_cmd=${create_cmd}" --network-type=${NETWORK_TYPE}"
fi

if [[ -n ${VPC_CIDR} ]] ; then
  create_cmd=${create_cmd}" --vpc-cidr=${VPC_CIDR}"
fi

if [[ -n ${TOLERATION} ]] ; then
  create_cmd=${create_cmd}" --toleration=${TOLERATION}"
fi

if [[ -n ${LABELS} ]] ; then
  create_cmd=${create_cmd}" --labels=${LABELS}"
fi

if [[ -n ${PODS_LABELS} ]] ; then
  create_cmd=${create_cmd}" --pods-labels=${PODS_LABELS}"
fi

set -x
if [[ -n ${RENDER} ]] ; then
  create_cmd=${create_cmd}" --render --render-sensitive "
  ${create_cmd} > hostedcluster.yaml
else
  ${create_cmd}
fi

