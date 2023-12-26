#
# INFRA_ID=heli-test-v2-vfgnk
HYPERSHIFT_CLI=hypershift

# resource tags
TAG_NAME := hypershift-ci-makefile-heli
TAG_VALUE := owned

# hypershift cli
BRANCH := main
# PR_NUMBER := 1234

# bucket
BUCKET_NAME := heli-test
BUCKET_REGION := us-east-2

# hypershift install
OCP_ARCH := amd64
AWS_CRENDENTIAL := $(HOME)/.aws/credentials
# OPERATOR_IMAGE := quay.io/hypershift/hypershift-operator:latest
AWS_PRIVATE_CREDS := $(HOME)/.aws/aws-private-creds
# HO_NAMESPACE := hypershift

# hypershift create
CLUSTER_NAME := heli-test
PULL_SSECRET := $(HOME)/pull-secret
AWS_CREDS :=$(HOME)/.aws/credentials
HYPERSHIFT_AWS_REGION := us-east-2
HC_NAMESPACE := clusters
SSH_KEY := $(HOME)/.ssh/id_rsa.pub

ENDPOINT_ACCESS := PublicAndPrivate
# enable AWS_EXTERNAL_DNS_DOMAIN and AWS_BASE_DOMAIN for publicAndPrivate or Private ENDPOINT_ACCESS
AWS_EXTERNAL_DNS_DOMAIN := hypershift-ext.qe.devcluster.openshift.com
AWS_BASE_DOMAIN := hypershift-ci.qe.devcluster.openshift.com
# AWS_BASE_DOMAIN := qe.devcluster.openshift.com

 RELEASE_IMAGE := registry.build05.ci.openshift.org/ci-ln-32xw52k/release:latest

# if RELEASE_IMAGE is not set, and RELEASE_IMAGE_SYNC_MGMT == true,
# the hosted cluster payload will set with mgmt image
# RELEASE_IMAGE_SYNC_MGMT := true


# RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.14.0-0.nightly-2023-07-18-085740
#INFRA_AVAILABILITY_POLICY := HighlyAvailable
#ZONES := us-east-2a,us-east-2b,us-east-2c
# HYPERSHIFT_ARCH := arm64
NODEPOOL_REPLICAS := 2
# RENDER := true
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml