#!/bin/sh
set -ex

HC_NAMESPACE=${HC_NAMESPACE:-"clusters"}
SSH_KEY=${SSH_KEY:-"$HOME/.ssh/id_rsa.pub"}

if [[ -z "${INFRA_ID}" ]] ; then
  INFRA_ID=$(oc get hc -n ${HC_NAMESPACE} ${CLUSTER_NAME} -ojsonpath='{.spec.infraID}')
fi

hypershift create bastion aws \
--aws-creds /Users/harry/.aws/credentials \
--infra-id ${INFRA_ID}  \
--region=${HYPERSHIFT_AWS_REGION} \
--ssh-key-file=${SSH_KEY}

# aws ec2 describe-instances --filter="Name=tag:kubernetes.io/cluster/heli-private-nlb-26m2h,Values=owned" | jq '.Reservations[] | .Instances[] | select(.PublicDnsName=="") | .PrivateIpAddress'
# ssh -o ProxyCommand="ssh ec2-user@3.136.25.157 -W %h:%p" core@10.0.133.36