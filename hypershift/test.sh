#!/bin/sh
set -e
echo "bucketname" ${BUCKET_NAME}
echo "zones" ${ZONES}
echo "PLATFORM" ${PLATFORM}

var="hypershift"

if [[ -n ${BUCKET_NAME} ]] ; then
  var=${var}" -v"
fi
echo var $var
${var}
