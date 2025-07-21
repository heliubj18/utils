#!/bin/sh

oc create secret generic hypershift-operator-oidc-provider-s3-credentials --from-file=credentials=/Users/harry/.aws/credentials --from-literal=bucket=heli-test-2  --from-literal=region=us-east-2 -n local-cluster
oc label secret hypershift-operator-oidc-provider-s3-credentials -n local-cluster cluster.open-cluster-management.io/backup=true