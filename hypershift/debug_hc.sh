#!/bin/sh
set -e

echo ">>>>>> check s3 bucket info"
echo "bucket config: BUCKET_NAME: $BUCKET_NAME BUCKET_REGION $BUCKET_REGION"
echo "bucket info in OCP: "
oc -n kube-public get cm oidc-storage-provider-s3-config -ojsonpath='{.data}' | jq
bucket_name=$(oc get cm -n kube-public oidc-storage-provider-s3-config  -ojsonpath='{.data.name}')
aws s3api head-bucket --bucket $bucket_name
echo

echo ">>>>> hypershift version"
hypershift -v
oc logs -n hypershift -lapp=operator --tail=-1 | head -1

echo ">>>>>> hostedcluster ${CLUSTER_NAME} conditions"
oc get hostedcluster ${CLUSTER_NAME} -n ${NAMESPACE} -ojsonpath='{.status.conditions}' | jq

echo ">>>>>> nodes info"
oc get awsmachines -A
oc get nodepool -A
oc get np -A -ojsonpath='{.items[*].status.conditions}' | jq


function check_hostedzone_condition()
{
  echo "check hostedcluster condition"
  echo "check kube-apiserver route ELB"

  echo "check ELB info by aws client"
  echo "check hostedzone kube-apiserver record"
  echo "get ELB hostedzone kube-apiserver record"
  echo "compare the route ELB and that in the hostedzone record"
  #oc get -n clusters-heli-test routes.route.openshift.io kube-apiserver -ojsonpath='{.status.ingress[].routerCanonicalHostname}' | cut -d. -f1| cut -d- -f1

}