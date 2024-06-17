#!/bin/bash

# Define environment-specific variables

BUCKET="$TF_VAR_project_name-$TF_VAR_environment-tf-state"
KEY="$TF_VAR_environment/$TF_VAR_project_name-remote-state.tfstate"
TABLE="$TF_VAR_project_name-$TF_VAR_environment-tf-locks"
REGION="$TF_VAR_region"

# Replace placeholders in the template
sed -e "s|__BUCKET__|$BUCKET|" -e "s|__KEY__|$KEY|" -e "s|__REGION__|$REGION|" -e "s|__TABLE__|$TABLE|" provider.tf.tmpl > provider.tf
