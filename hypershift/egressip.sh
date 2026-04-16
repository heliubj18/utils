#!/bin/sh

och run hello-world   --image=nginx:alpine   --restart=Never   --port=80
och label ns default org=qe
och label pod hello-world color=pink
och label no ip-10-0-13-196.ec2.internal k8s.ovn.org/egress-assignable=
och rsh hello-world curl www.google.com -I

##
#$ och -n openshift-ovn-kubernetes rsh ovnkube-node-c92v7
#_uuid               : 08bf4444-6438-489f-9232-c88f3a14bd87
#allowed_ext_ips     : []
#exempted_ext_ips    : []
#external_ids        : {ip-family=ip4, "k8s.ovn.org/id"="default-network-controller:EgressIP:egressip-heli_default/hello-world:ip4", "k8s.ovn.org/name"="egressip-heli_default/hello-world", "k8s.ovn.org/owner-controller"=default-network-controller, "k8s.ovn.org/owner-type"=EgressIP}
#external_ip         : "10.0.29.99"
#external_mac        : []
#external_port_range : "32768-60999"
#gateway_port        : []
#logical_ip          : "10.134.0.23"
#logical_port        : k8s-ip-10-0-29-98.ec2.internal
#match               : ""
#options             : {stateless="false"}
#priority            : 0
#type                : snat