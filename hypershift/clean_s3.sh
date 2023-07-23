#!/bin/sh
set -e

# delete s3 buckets by tags
TAG_NAME="hypershift-ci-makefile"
TAG_VALUE="owned"
query='{"Type":"TAG_FILTERS_1_0","Query":"{\"ResourceTypeFilters\":[\"AWS::S3::Bucket\"],\"TagFilters\":[{\"Key\":\"'"$TAG_NAME"'\",\"Values\":[\"'"$TAG_VALUE"'\"]}]}"}'
buckets=$(aws resource-groups search-resources  --resource-query $query  --output json  | jq -r '.ResourceIdentifiers[].ResourceArn | split(":") | .[5]')
echo "buckets: " $buckets
for bucket in $buckets; do
    echo "Deleting bucket: $bucket"
    objects=$(aws s3 ls "s3://$bucket" --recursive --output text | awk '{print $4}')
    for object in $objects; do
        echo "Deleting object: s3://$bucket/$object"
        aws s3 rm "s3://$bucket/$object"
    done
    aws s3api delete-bucket --bucket "$bucket"
done