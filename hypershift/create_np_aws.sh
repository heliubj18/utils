#!/bin/sh
set -ex

NAMESPACE=${NAMESPACE:-"clusters"}
HYPERSHIFT_CLI=${HYPERSHIFT_CLI:-"hypershift"}

create_cmd="${HYPERSHIFT_CLI} create nodepool aws \
--name=${NODEPOOL_NAME} \
--cluster-name=${CLUSTER_NAME} \
--node-count=${NODE_COUNT} "

#if [[ -n "${RELEASE_IMAGE}" ]] ; then
#  create_cmd=${create_cmd}" --release-image=${RELEASE_IMAGE}"
#fi

if [[ -n "${NODEPOOL_RELEASE_IMAGE}" ]] ; then
  create_cmd=${create_cmd}" --release-image=${NODEPOOL_RELEASE_IMAGE}"
fi

if [[ -n "${HC_NAMESPACE}" ]] ; then
  create_cmd=${create_cmd}" --namespace=${HC_NAMESPACE}"
fi

if [[ -n ${NODE_UPGRADE_TYPE} ]] ; then
  create_cmd=${create_cmd}" --node-upgrade-type=${NODE_UPGRADE_TYPE} "
fi

if [[ -n ${NODEPOOL_ARCH} ]] ; then
  create_cmd=${create_cmd}" --arch=${NODEPOOL_ARCH}"
fi

if [[ -n ${SECURITY_GROUP_ID} ]] ; then
  create_cmd=${create_cmd}" --securitygroup-id=${SECURITY_GROUP_ID}"
fi

set -x
if [[ -n ${RENDER} ]] ; then
  create_cmd=${create_cmd}" --render"
  ${create_cmd} > nodepool.yaml
else
  ${create_cmd}
fi

