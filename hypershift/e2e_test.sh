#!/bin/sh
# set -x

#oc login https://apiserver:6443 --exec-plugin=oc-oidc --issuer-url=$ISSUER_URL --client-id=$CLIENT_ID --extra-scopes=email --callback-port=8080
sh $(dirname "$0")/install_keycloak.sh

export SHARED_DIR="/tmp"
source ${SHARED_DIR}/runtime_env
export TECH_PREVIEW_NO_UPGRADE=true
# --e2e.aws-oidc-s3-bucket-name hypershift-ci-2-oidc
# source $(dirname "$0")/../.env

test-e2e -test.v -test.run TestExternalOIDCTechPreview \
  --e2e.aws-region ${HYPERSHIFT_AWS_REGION} \
  --e2e.aws-credentials-file ${AWS_CRENDENTIAL} \
  --e2e.base-domain ${AWS_BASE_DOMAIN}  \
  --e2e.aws-oidc-s3-region ${BUCKET_REGION} \
  --e2e.aws-oidc-s3-bucket-name ${BUCKET_NAME} \
  --e2e.pull-secret-file  /Users/harry/pull-secret \
  --e2e.external-oidc-provider keycloak  \
  --e2e.external-oidc-cli-client-id ${KEYCLOAK_CLI_CLIENT_ID}  \
  --e2e.external-oidc-console-client-id ${CONSOLE_CLIENT_ID}  \
  --e2e.external-oidc-issuer-url ${KEYCLOAK_ISSUER}  \
  --e2e.external-oidc-console-secret ${CONSOLE_CLIENT_SECRET_VALUE}  \
  --e2e.external-oidc-ca-bundle-file ${KEYCLOAK_CA_BUNDLE_FILE} \
  --e2e.latest-release-image ${RELEASE_IMAGE} \
  --e2e.external-oidc-test-users ${KEYCLOAK_TEST_USERS} \
  --e2e.availability-zones ${ZONES}