#!/bin/sh

# hypershift-ext.qe.devcluster.openshift.com
echo "check records of hostedzone: hypershift-ext.qe.devcluster.openshift.com"
echo "***************************************hypershift-ext.qe.devcluster.openshift.com"
echo
aws route53 list-resource-record-sets --hosted-zone-id Z10342632XUGMJAO43RC | jq '.ResourceRecordSets'
echo

# hypershift-ci.qe.devcluster.openshift.com
echo "check records of hostedzone: hypershift-ci.qe.devcluster.openshift.com"
echo "***************************************hypershift-ci.qe.devcluster.openshift.com"
echo
aws route53 list-resource-record-sets --hosted-zone-id Z04732803DES2BILYZID7 | jq '.ResourceRecordSets'
echo
