#!/bin/sh
set -eo pipefail
source $(dirname "$0")/pre_check.sh
check_hypershift_install_dependency

# AWS_EXTERNAL_DNS_DOMAIN=${AWS_EXTERNAL_DNS_DOMAIN:-"hypershift-ext.qe.devcluster.openshift.com"}
AWS_CRENDENTIAL=${AWS_CRENDENTIAL:-"${HOME}/.aws/credentials"}
# BUCKET_NAME=${BUCKET_NAME:-"hypershift-demo-oidc"}
BUCKET_REGION=$(aws s3api get-bucket-location --bucket $BUCKET_NAME --output text)
#if [[ -z $BUCKET_REGION || $BUCKET_REGION == "None" ]] ; then
#  BUCKET_REGION="us-east-1"
#fi

OPERATOR_IMAGE=${OPERATOR_IMAGE:-"quay.io/hypershift/hypershift-operator:latest"}

if [[ $OCP_ARCH == "arm64" ]]; then
  OPERATOR_IMAGE="quay.io/hypershift/hypershift-operator:latest-arm64"
fi

create_cmd="${HYPERSHIFT_CLI} install \
--oidc-storage-provider-s3-credentials=${AWS_CRENDENTIAL} \
--oidc-storage-provider-s3-bucket-name=${BUCKET_NAME} \
--oidc-storage-provider-s3-region=${BUCKET_REGION} \
--enable-defaulting-webhook=true \
--enable-cvo-management-cluster-metrics-access \
--platform-monitoring=All \
"
if [[ -n ${HO_NAMESPACE} ]] ; then
  create_cmd=${create_cmd}" --namespace=${HO_NAMESPACE}"
fi

if [[ ${ENDPOINT_ACCESS} == "PublicAndPrivate" ]] ||  [[ ${ENDPOINT_ACCESS} == "Private" ]] ; then
  create_cmd=${create_cmd}" --private-platform AWS \
      --aws-private-creds ${AWS_PRIVATE_CREDS}  \
      --aws-private-region=${HYPERSHIFT_AWS_REGION} \
      --external-dns-provider=aws \
      --external-dns-credentials=${AWS_CRENDENTIAL} \
      --external-dns-domain-filter=${AWS_EXTERNAL_DNS_DOMAIN} \
      --enable-cvo-management-cluster-metrics-access "
fi

set -x
$create_cmd

#hypershift install --hypershift-image=${OPERATOR_IMAGE} \
#--oidc-storage-provider-s3-credentials=${AWS_CRENDENTIAL} \
#--oidc-storage-provider-s3-bucket-name=${BUCKET_NAME} \
#--oidc-storage-provider-s3-region=${BUCKET_REGION} \
#--enable-defaulting-webhook=true
#--platform-monitoring=All \
#--enable-ci-debug-output \
#--aws-private-creds=${AWS_PRIVATE_CREDS} \
#--aws-private-region=${HYPERSHIFT_AWS_REGION} \
#--external-dns-provider=aws \
#--external-dns-credentials=${AWS_CRENDENTIAL} \
#--external-dns-domain-filter=${AWS_EXTERNAL_DNS_DOMAIN}
