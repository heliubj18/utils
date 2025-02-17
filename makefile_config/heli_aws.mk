# bucket
BUCKET_NAME := heli-test
BUCKET_REGION := us-east-2

#
INFRA_ID=heli-test-02-62gdr
HYPERSHIFT_CLI=hypershift

# resource tags
TAG_NAME := hypershift-ci-makefile-heli
TAG_VALUE := owned

# hypershift cli
BRANCH := main
# PR_NUMBER := 1234


# hypershift install
OCP_ARCH := amd64
AWS_CRENDENTIAL := $(HOME)/.aws/credentials
# OPERATOR_IMAGE := quay.io/heli/hypershift-operator:4.18
AWS_PRIVATE_CREDS := $(HOME)/.aws/aws-private-creds
# HO_NAMESPACE := hypershift
# ENABLE_WEBHOOK := true

# hypershift create
CLUSTER_NAME := heli-test

PULL_SSECRET := $(HOME)/pull-secret
AWS_CREDS :=$(HOME)/.aws/credentials
HYPERSHIFT_AWS_REGION := ap-southeast-5
HC_NAMESPACE := clusters
SSH_KEY := $(HOME)/.ssh/id_rsa.pub
HO_TECH_PREVIEW_NO_UPGRADE := true

ENDPOINT_ACCESS := Public
#PublicAndPrivate
# enable AWS_EXTERNAL_DNS_DOMAIN and AWS_BASE_DOMAIN for publicAndPrivate or Private ENDPOINT_ACCESS
# AWS_EXTERNAL_DNS_DOMAIN := hypershift-ext.qe.devcluster.openshift.com
# AWS_BASE_DOMAIN := hypershift-ci.qe.devcluster.openshift.com
 AWS_BASE_DOMAIN := qe.devcluster.openshift.com

 RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.19.0-0.nightly-2025-01-19-211100
#  RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.16.0-0.nightly-2024-12-05-111103

 # RELEASE_IMAGE := registry.ci.openshift.org/ocp/release@sha256:d2b7f211a67245f52e76d40aade72a53007c2e8b40872bb88a68d87e6cea75ae

# RELEASE_IMAGE := registry.ci.openshift.org/ocp/release:4.15.0-0.nightly-2024-07-07-225951
# ENABLE_FIPS := true
# if RELEASE_IMAGE is not set, and RELEASE_IMAGE_SYNC_MGMT == true
# the hosted cluster payload will set with mgmt image
# RELEASE_IMAGE_SYNC_MGMT := true

# CONTROL_PLANE_OPERATOR := quay.io/heli/hypershift-control-plane:pr4787
# VPC_CIDR = 10.1.0.0/16
# INFRA_AVAILABILITY_POLICY := HighlyAvailable
# CP_AVAILABILITY_POLICY := HighlyAvailable
 # ZONES := us-east-2a,us-east-2b,us-east-2c
# HYPERSHIFT_ARCH := arm64
# HYPERSHIFT_MULTI_ARCH := true
# TOLERATION := key=heli-test,operator=Exists,effect=NoSchedule
 NODEPOOL_REPLICAS := 1
# RENDER := true
# IMAGE_CONTENT_SOURCES := ./makefile_config/icsp.yaml
# LABELS := heli-test=owned
 PODS_LABELS := heli-test-v1=owned,heli-test-v2=owned
# NETWORK_TYPE := OpenShiftSDN
# DEDICATED := true

## nodepool settings
NODEPOOL_NAME := heli-test
NODE_COUNT := 1

#Replace, InPlace (default Replace)
# NODE_UPGRADE_TYPE := Inplace

# arm64, amd64) (default "amd64")
# NODEPOOL_ARCH := amd64

# custom sg
# SECURITY_GROUP_ID := sg-067f2cc0fea688d8d

# custom sg
# NODEPOOL_RELEASE_IMAGE := registry.ci.openshift.org/ocp/release@sha256:5fa08cfafb0c73c17c859facb5d91a008588ef6ab49303fbad2bfdd096fd3bf8