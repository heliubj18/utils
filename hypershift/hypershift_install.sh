#!/bin/sh
set -eo pipefail
source $(dirname "$0")/pre_check.sh
check_hypershift_install_dependency

AWS_EXTERNAL_DNS_DOMAIN=${AWS_EXTERNAL_DNS_DOMAIN:-"hypershift-ext.qe.devcluster.openshift.com"}
AWS_CRENDENTIAL=${AWS_CRENDENTIAL:-"$HOME/.aws/credentials"}
BUCKET_NAME=${BUCKET_NAME:-"hypershift-demo-oidc"}
BUCKET_REGION=$(aws s3api get-bucket-location --bucket $BUCKET_NAME --output text)
if [[ -z $region || $region == "None" ]] ; then
  BUCKET_REGION="us-east-1"
fi

if [[ $OCP_ARCH == "arm64" ]]; then
  OPERATOR_IMAGE="quay.io/hypershift/hypershift-operator:latest-arm64"
fi

bin/hypershift install --hypershift-image="${OPERATOR_IMAGE}" \
--oidc-storage-provider-s3-credentials=${AWS_CRENDENTIAL} \
--oidc-storage-provider-s3-bucket-name=${BUCKET_NAME} \
--oidc-storage-provider-s3-region=${BUCKET_REGION} \
--platform-monitoring=All \
--enable-ci-debug-output \
--private-platform=AWS \
--aws-private-creds=${AWS_PRIVATE_CREDS} \
--aws-private-region="${HYPERSHIFT_AWS_REGION}" \
--external-dns-provider=aws \
--external-dns-credentials=${AWS_CRENDENTIAL} \
--external-dns-domain-filter=${AWS_EXTERNAL_DNS_DOMAIN}