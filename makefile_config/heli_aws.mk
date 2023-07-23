# hypershift cli
BRANCH := main
# PR_NUMBER := 1234

# bucket
BUCKET_NAME := "heli-test"
BUCKET_REGION := "us-east-2"

# hypershift install
OCP_ARCH := "amd64"
AWS_EXTERNAL_DNS_DOMAIN := "hypershift-ext.qe.devcluster.openshift.com"
AWS_CRENDENTIAL := "$HOME/.aws/credentials"
# OPERATOR_IMAGE := "quay.io/hypershift/hypershift-operator:latest"
AWS_PRIVATE_CREDS := "$HOME/.aws/aws_private_creds"

# hypershift create
CLUSTER_NAME := "heli-test"
ENDPOINT_ACCESS := "PublicAndPrivate"
PULL_SSECRET := "$HOME/pull-secret"
AWS_CREDS :="$HOME/.aws/credentials"
HYPERSHIFT_AWS_REGION := "us-east-2"
NAMESPACE := "clusters"
AWS_EXTERNAL_DNS_DOMAIN := "hypershift-ext.qe.devcluster.openshift.com"
AWS_BASE_DOMAIN := "hypershift-ci.qe.devcluster.openshift.com"

# RELEASE_IMAGE := "registry.ci.openshift.org/ocp/release:4.14.0-0.nightly-2023-07-18-085740"
# INFRA_AVAILABILITY_POLICY := "HighlyAvailable"
# ZONES := "us-east-2a,us-east-2b,us-east-2c "
# HYPERSHIFT_ARCH := arm64
# NODEPOOL_REPLICAS := "2"
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml