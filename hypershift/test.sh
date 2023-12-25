#!/bin/sh
set -e
echo "print some variables in the configuration file $CONFIG_FILE"
echo "bucketname" ${BUCKET_NAME}
echo "zones" ${ZONES}
echo "PLATFORM" ${PLATFORM}

var="hypershift"

if [[ -n ${BUCKET_NAME} ]] ; then
  var=${var}" -v"
fi

${var}
