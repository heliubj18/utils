#
INFRA_ID=heli-test-xwblx
HYPERSHIFT_CLI=hypershift

# resource tags
TAG_NAME := hypershift-ci-makefile-heli
TAG_VALUE := owned

# hypershift cli
BRANCH := main
# PR_NUMBER := 1234

# bucket
BUCKET_NAME := wenwang-test
BUCKET_REGION := us-east-2

# hypershift install
OCP_ARCH := amd64
AWS_CRENDENTIAL := $(HOME)/.aws/credentials
# OPERATOR_IMAGE := quay.io/hypershift/hypershift-operator:4.13
AWS_PRIVATE_CREDS := $(HOME)/.aws/aws-private-creds
# HO_NAMESPACE := hypershift

# hypershift create
CLUSTER_NAME := wenwang-test

PULL_SSECRET := $(HOME)/pull-secret
AWS_CREDS :=$(HOME)/.aws/credentials
HYPERSHIFT_AWS_REGION := us-east-2
HC_NAMESPACE := clusters
SSH_KEY := $(HOME)/.ssh/id_rsa.pub

ENDPOINT_ACCESS := Public
#PublicAndPrivate
# enable AWS_EXTERNAL_DNS_DOMAIN and AWS_BASE_DOMAIN for publicAndPrivate or Private ENDPOINT_ACCESS
# AWS_EXTERNAL_DNS_DOMAIN := hypershift-ext.qe.devcluster.openshift.com
# AWS_BASE_DOMAIN := hypershift-ci.qe.devcluster.openshift.com
# AWS_BASE_DOMAIN := qe.devcluster.openshift.com

# AWS_EXTERNAL_DNS_DOMAIN := heli-test.qe.devcluster.openshift.com

# RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.16.0-0.nightly-2024-01-24-133352

# if RELEASE_IMAGE is not set, and RELEASE_IMAGE_SYNC_MGMT == true,
# the hosted cluster payload will set with mgmt image
 RELEASE_IMAGE_SYNC_MGMT := true


# RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.15.0-0.nightly-2024-01-22-160236
#INFRA_AVAILABILITY_POLICY := HighlyAvailable
# CP_AVAILABILITY_POLICY := HighlyAvailable
#ZONES := us-east-2a,us-east-2b,us-east-2c
# HYPERSHIFT_ARCH := arm64
NODEPOOL_REPLICAS := 2
# RENDER := true
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml

# NETWORK_TYPE := Other