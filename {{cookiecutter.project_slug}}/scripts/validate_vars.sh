#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_tfvars>"
  exit 1
fi

TFVARS_FILE=$1

# Extract variables that do not have a default value
grep -Po 'variable "\K[^"]+' variables.tf > /tmp/all_vars.txt
grep -Pzo 'variable "[^"]+"\s*{[^}]*default\s*=\s*[^}]*}' variables.tf | grep -Po 'variable "\K[^"]+' > /tmp/default_vars.txt
comm -23 <(sort /tmp/all_vars.txt) <(sort /tmp/default_vars.txt) > /tmp/required_vars.txt

# Print extracted required variables
echo "Required variables without default values:"
cat /tmp/required_vars.txt

# Check if all required variables are defined in the tfvars file
REQUIRED_VARS=$(cat /tmp/required_vars.txt)
mapfile -t DEFINED_VARS < <(grep -oP '^\s*[^#]\K[^=]+' "$TFVARS_FILE" | tr -d ' ')

for var in $REQUIRED_VARS; do
  if ! [[ " ${DEFINED_VARS[@]} " =~ " ${var} " ]]; then
    echo "Error: Required variable '$var' is not defined in $TFVARS_FILE"
    exit 1
  fi
done

echo "All required variables are defined in $TFVARS_FILE"
