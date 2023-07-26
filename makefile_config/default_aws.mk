# resource tags
TAG_NAME = hypershift-ci-makefile-dft
TAG_VALUE = owned

# hypershift cli
BRANCH := main
# PR_NUMBER := 1234

# bucket
BUCKET_NAME := hypershift-example-bucket
BUCKET_REGION := us-east-2

# hypershift install
# OCP_ARCH := amd64
# AWS_EXTERNAL_DNS_DOMAIN := hypershift-ext.qe.devcluster.openshift.com
AWS_CRENDENTIAL := $(HOME)/.aws/credentials
# OPERATOR_IMAGE := quay.io/hypershift/hypershift-operator:latest
# AWS_PRIVATE_CREDS := $(HOME)/.aws/aws-private-creds

# hypershift create
CLUSTER_NAME := hypershift-example
# ENDPOINT_ACCESS := PublicAndPrivate
PULL_SSECRET := $(HOME)/pull-secret
AWS_CREDS :=$(HOME)/.aws/credentials
HYPERSHIFT_AWS_REGION := us-east-2
NAMESPACE := clusters
# AWS_EXTERNAL_DNS_DOMAIN := hypershift-ext.qe.devcluster.openshift.com
AWS_BASE_DOMAIN := qe.devcluster.openshift.com

# if RELEASE_IMAGE is not set, and RELEASE_IMAGE_SYNC_MGMT == true,
# the hosted cluster payload will set with mgmt image
# RELEASE_IMAGE_SYNC_MGMT := true

# RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.14.0-0.nightly-2023-07-18-085740
# INFRA_AVAILABILITY_POLICY := HighlyAvailable
# ZONES := us-east-2a,us-east-2b,us-east-2c 
# HYPERSHIFT_ARCH := arm64
# NODEPOOL_REPLICAS := 2
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml