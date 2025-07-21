#!/bin/sh
set -x

# --e2e.aws-oidc-s3-bucket-name hypershift-ci-2-oidc
source $(dirname "$0")/../.env
test-e2e -test.run TestExternalOIDC \
  --e2e.aws-region ${HYPERSHIFT_AWS_REGION} \
  --e2e.aws-credentials-file ${AWS_CRENDENTIAL} \
  --e2e.base-domain ${AWS_BASE_DOMAIN}  \
  --e2e.aws-oidc-s3-region ${BUCKET_REGION} \
  --e2e.aws-oidc-s3-bucket-name ${BUCKET_NAME} \
  --e2e.pull-secret-file  /Users/harry/pull-secret \
  --e2e.enable-external-oidc true \
  --e2e.external-oidc-cli-client-id ${CLI_CLIENT_ID} \
  --e2e.external-oidc-console-client-id ${CONSOLE_CLIENT_ID} \
  --e2e.external-oidc-issuer-url ${ISSUER_URL} \
  --e2e.external-oidc-console-secret ${CONSOLE_SECRET} \
  --e2e.latest-release-image ${RELEASE_IMAGE}