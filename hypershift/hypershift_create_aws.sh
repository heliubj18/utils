#!/bin/sh

CLUSTER_NAME=${CLUSTER_NAME:-"heli-test-$RANDOM"}
PULL_SSECRET=${PULL_SSECRET:-"$HOME/pull-secret"}
AWS_CREDS=${AWS_CREDS:-"$HOME/.aws/credentials"}
NODEPOOL_REPLICAS=${NODEPOOL_REPLICAS:-"2"}
HYPERSHIFT_AWS_REGION=${HYPERSHIFT_AWS_REGION:-"us-east-2"}
NAMESPACE=${NAMESPACE:-"clusters"}
AWS_EXTERNAL_DNS_DOMAIN=${AWS_EXTERNAL_DNS_DOMAIN:-"hypershift-ext.qe.devcluster.openshift.com"}
AWS_BASE_DOMAIN=${AWS_BASE_DOMAIN:-"hypershift-ci.qe.devcluster.openshift.com"}

hypershift create cluster aws \
--name=${CLUSTER_NAME} \
--endpoint-access=${ENDPOINT_ACCESS} \
--pull-secret=${PULL_SSECRET} \
--aws-creds=${AWS_CREDS} \
--node-pool-replicas=${NODEPOOL_REPLICAS} \
--region=${HYPERSHIFT_AWS_REGION} \
--namespace=${NAMESPACE} \
--base-domain=${AWS_BASE_DOMAIN} \
--external-dns-domain=${AWS_EXTERNAL_DNS_DOMAIN} \
--annotations=hypershift.openshift.io/cleanup-cloud-resources="true" \
--infra-availability-policy=${INFRA_AVAILABILITY_POLICY} \
--zones=${ZONES} \
--arch=${HYPERSHIFT_ARCH} \
--image-content-sources=${IMAGE_CONTENT_SOURCES} \
--release-image=${RELEASE_IMAGE}