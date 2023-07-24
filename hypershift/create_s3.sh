#!/bin/sh
set -e

source $(dirname "$0")/pre_check.sh

# return a random s3 bucket name
function get_bucket_name()
{
  local _bucket_name=example
  length=5
  os=$(uname)
  if [ "$os" == "Darwin" ]; then
    _bucket_name=$(gtr -dc a-z0-9 </dev/urandom | head -c "$length" ; echo '')
  else
    _bucket_name=$(tr -dc a-z0-9 </dev/urandom | head -c "$length" ; echo '')
  fi
  echo hypershift-$_bucket_name
}

#global config
BUCKET_REGION=${BUCKET_REGION:-"us-east-2"}
BUCKET_NAME=${BUCKET_NAME:-`get_bucket_name`}
TAG_NAME=${TAG_NAME:-"hypershift-ci-makefile-RANDOM"}
TAG_VALUE=${TAG_VALUE:-"owned"}

#function cleanup() {
#  echo "Error occurs, cleaning up s3 bucket"
#  if aws s3api head-bucket --bucket "${BUCKET_NAME}" >/dev/null 2>&1; then
#      echo "Bucket ${BUCKET_NAME} exists, deleting..."
#      aws s3api delete-bucket --bucket "${BUCKET_NAME}"
#  fi
#}
#trap 'cleanup' ERR

#check_s3_dependency
echo "bucket name:" ${BUCKET_NAME} "region:" ${BUCKET_REGION}

if [[ ${BUCKET_REGION} == "us-east-1" ]] ; then
  aws s3api create-bucket --bucket ${BUCKET_REGION}
else
  aws s3api create-bucket  --create-bucket-configuration \
      LocationConstraint=${BUCKET_REGION} --region=${BUCKET_REGION} --bucket ${BUCKET_NAME}
fi

aws s3api put-bucket-tagging --bucket ${BUCKET_NAME} --tagging 'TagSet=[{Key='"$TAG_NAME"',Value='"$TAG_VALUE"'}]'

aws s3api delete-public-access-block --bucket ${BUCKET_NAME}
pub_policy='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'"${BUCKET_NAME}"'/*"
        }
    ]
}'
aws s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy "$pub_policy"
aws s3api head-bucket --bucket "${BUCKET_NAME}"





