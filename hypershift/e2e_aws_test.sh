#!/bin/sh
# set -x

#oc login https://apiserver:6443 --exec-plugin=oc-oidc --issuer-url=$ISSUER_URL --client-id=$CLIENT_ID --extra-scopes=email --callback-port=8080

export SHARED_DIR="/tmp"
source ${SHARED_DIR}/runtime_env
export TECH_PREVIEW_NO_UPGRADE=true
# --e2e.aws-oidc-s3-bucket-name hypershift-ci-2-oidc

test-e2e -test.v -test.run TestCreateCluster \
  --e2e.aws-region ${HYPERSHIFT_AWS_REGION} \
  --e2e.aws-credentials-file ${AWS_CRENDENTIAL} \
  --e2e.base-domain ${AWS_BASE_DOMAIN}  \
  --e2e.aws-oidc-s3-region ${BUCKET_REGION} \
  --e2e.aws-oidc-s3-bucket-name ${BUCKET_NAME} \
  --e2e.pull-secret-file  /Users/harry/pull-secret \
  --e2e.latest-release-image ${RELEASE_IMAGE} \
  --e2e.previous-release-image "${OCP_IMAGE_PREVIOUS}" \
  --e2e.external-oidc-test-users ${KEYCLOAK_TEST_USERS} \
  --e2e.availability-zones ${ZONES} \
  --e2e.node-pool-replicas 1 \
  --e2e.additional-tags="expirationDate=$(date -u -v+4H +"%Y-%m-%dT%H:%MZ")" \
    --e2e.aws-endpoint-access=PublicAndPrivate \
    --e2e.external-dns-domain=service.ci.hypershift.devcluster.openshift.com