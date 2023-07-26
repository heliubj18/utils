#!/bin/sh
set -ex
echo "bucketname" ${BUCKET_NAME}
echo "zones" ${ZONES}

var="hypershift"

if [[ -n ${BUCKET_NAME} ]] ; then
  var=${var}+" -v"
fi
echo var $var
${var}
