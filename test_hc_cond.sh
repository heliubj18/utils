#!/bin/sh
 CLUSTER_NAME=hypershift-ci-360733
 oidc_cond=$(oc -n clusters get hostedcluster $CLUSTER_NAME -o jsonpath='{.status.conditions[?(@.type=="ValidOIDCConfiguration")].status}')
 echo ValidOIDCConfiguration $oidc_cond
 aws_identity_cond=$(oc -n clusters get hostedcluster $CLUSTER_NAME -o jsonpath='{.status.conditions[?(@.type=="ValidAWSIdentityProvider")].status}')
 echo ValidAWSIdentityProvider $aws_identity_cond
 oc -n hypershift rsh -c operator operator-68d5f94f44-dpp7w  curl 127.0.0.1:9000/metrics | grep hypershift_cluster_invalid_aws_creds
 echo