#!/bin/sh

alias och='oc --kubeconfig=/Users/harry/Downloads/hc.kubeconfig'

cilium_ns=$(och get ns cilium --ignore-not-found)
if [[ -z "$cilium_ns" ]]; then
  och create ns cilium
fi

och label ns cilium security.openshift.io/scc.podSecurityLabelSync=false pod-security.kubernetes.io/enforce=privileged pod-security.kubernetes.io/audit=privileged pod-security.kubernetes.io/warn=privileged --overwrite
CILIUM_VERSION=1.15.1

# apply isovalent cilium CNI
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-03-cilium-ciliumconfigs-crd.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00000-cilium-namespace.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00001-cilium-olm-serviceaccount.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00002-cilium-olm-deployment.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00003-cilium-olm-service.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00004-cilium-olm-leader-election-role.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00005-cilium-olm-role.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00006-leader-election-rolebinding.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00007-cilium-olm-rolebinding.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00008-cilium-cilium-olm-clusterrole.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00009-cilium-cilium-clusterrole.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00010-cilium-cilium-olm-clusterrolebinding.yaml"
och apply -f "https://raw.githubusercontent.com/isovalent/olm-for-cilium/main/manifests/cilium.v${CILIUM_VERSION}/cluster-network-06-cilium-00011-cilium-cilium-clusterrolebinding.yaml"

PODCIDR=$(och get network cluster -o jsonpath='{.spec.clusterNetwork[0].cidr}')
HOSTPREFIX=$(och get network cluster -o jsonpath='{.spec.clusterNetwork[0].hostPrefix}')
export PODCIDR=$PODCIDR
export HOSTPREFIX=$HOSTPREFIX

echo '
apiVersion: cilium.io/v1alpha1
kind: CiliumConfig
metadata:
  name: cilium
  namespace: cilium
spec:
  debug:
    enabled: true
  k8s:
    requireIPv4PodCIDR: true
  logSystemLoad: true
  bpf:
    preallocateMaps: true
  etcd:
    leaseTTL: 30s
  ipv4:
    enabled: true
  ipv6:
    enabled: false
  identityChangeGracePeriod: 0s
  ipam:
    mode: "cluster-pool"
    operator:
      clusterPoolIPv4PodCIDRList:
        - "${PODCIDR}"
      clusterPoolIPv4MaskSize: "${HOSTPREFIX}"
  nativeRoutingCIDR: "${PODCIDR}"
  endpointRoutes: {enabled: true}
  clusterHealthPort: 9940
  tunnelPort: 4789
  cni:
    binPath: "/var/lib/cni/bin"
    confPath: "/var/run/multus/cni/net.d"
    chainingMode: portmap
  prometheus:
    serviceMonitor: {enabled: false}
  hubble:
    tls: {enabled: false}
  sessionAffinity: true
' | envsubst > /tmp/ciliumconfig.json

och apply -f /tmp/ciliumconfig.json