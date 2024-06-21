#!/bin/bash

# Map of MIME types and extensions
declare -A mime_types
mime_types=( ["html"]="text/html"
             ["css"]="text/css"
             ["js"]="application/javascript"
             ["png"]="image/png"
             ["jpg"]="image/jpeg"
             ["jpeg"]="image/jpeg"
             ["json"]="application/json"
             ["gif"]="image/gif"
             ["svg"]="image/svg+xml"
             ["ico"]="image/x-icon"
             ["woff"]="font/woff"
             ["woff2"]="font/woff2"
             ["ttf"]="font/ttf"
             ["eot"]="application/vnd.ms-fontobject"
           )

# Function to get MIME type based on file extension
get_mime_type() {
  local file_extension=$1
  echo "${mime_types[$file_extension]:-application/octet-stream}"
}

# Directory and S3 bucket as input parameters
DIRECTORY=$1
BUCKET_NAME=$2

# Check if the directory and bucket name are provided
if [ -z "$DIRECTORY" ] || [ -z "$BUCKET_NAME" ]; then
  echo "Usage: $0 <directory> <bucket-name>"
  exit 1
fi

# Loop through each file in the directory
for FILE in $(find "$DIRECTORY" -type f); do
  EXTENSION="${FILE##*.}"
  MIME_TYPE=$(get_mime_type "$EXTENSION")
  S3_KEY="${FILE#$DIRECTORY/}"
  echo "Updating $S3_KEY with MIME type $MIME_TYPE"
  aws s3 cp "s3://$BUCKET_NAME/$S3_KEY" "s3://$BUCKET_NAME/$S3_KEY" --content-type "$MIME_TYPE" --metadata-directive REPLACE
done
