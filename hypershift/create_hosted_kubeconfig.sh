#!/bin/sh
set -ex
target_dir="$HOME/Downloads"
if [ -n "$HOSTEDCLUSTER_KUBECONFIG_DIR" ] ; then
  target_dir=$HOSTEDCLUSTER_KUBECONFIG_DIR
fi


# cluster_name=$(oc get hostedcluster -n ${HC_NAMESPACE} ${CLUSTER_NAME} -ojsonpath='{.items[].metadata.name}')
oc get secret -n ${HC_NAMESPACE} ${CLUSTER_NAME}-admin-kubeconfig -ojsonpath='{.data.kubeconfig}' | base64 -d > $target_dir/hc.kubeconfig
oc --kubeconfig=$target_dir/hc.kubeconfig get node
oc --kubeconfig=$target_dir/hc.kubeconfig get co