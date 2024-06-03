#
INFRA_ID=heli-test-02-62gdr
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
# OPERATOR_IMAGE := quay.io/hypershift/hypershift-operator:4.15
AWS_PRIVATE_CREDS := $(HOME)/.aws/aws-private-creds
# HO_NAMESPACE := hypershift
# ENABLE_WEBHOOK := true

# hypershift create
CLUSTER_NAME := huiranwang-test

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
 AWS_BASE_DOMAIN := qe.devcluster.openshift.com

# RELEASE_IMAGE := registry.build03.ci.openshift.org/ci-ln-54id7yt/release@sha256:ddc01c15c15f82f758d8e7c86c6b56e27373221dfd84a7a88d44c3902deae5ad

# ENABLE_FIPS := true
# if RELEASE_IMAGE is not set, and RELEASE_IMAGE_SYNC_MGMT == true,
# the hosted cluster payload will set with mgmt image
RELEASE_IMAGE_SYNC_MGMT := true

# CONTROL_PLANE_OPERATOR := quay.io/heli/hypershift-control-plane:audit-log

#INFRA_AVAILABILITY_POLICY := HighlyAvailable
# CP_AVAILABILITY_POLICY := HighlyAvailable
#ZONES := us-east-2a,us-east-2b,us-east-2c
# HYPERSHIFT_ARCH := arm64
 NODEPOOL_REPLICAS := 1
# RENDER := true
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml

# NETWORK_TYPE := Other


## nodepool settings
NODEPOOL_NAME := heli-test
NODE_COUNT := 1

#Replace, InPlace (default Replace)
# NODE_UPGRADE_TYPE := Replace

# arm64, amd64) (default "amd64")
# NODEPOOL_ARCH := amd64

# custom sg
# SECURITY_GROUP_ID := sg-067f2cc0fea688d8d

# custom sg
# NODEPOOL_RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.14.0-0.nightly-2024-03-07-200645