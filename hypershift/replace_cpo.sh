#!/bin/sh

oc annotate -n $HC_NAMESPACE $CLUSTER_NAME hypershift.openshift.io/control-plane-operator-image=$CONTROL_PLANE_OPERATOR
