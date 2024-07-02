#!/bin/bash

# Check if the argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 json-defs/backend-project-name.json"
    exit 1
fi

# Insert shared functions here
source ./scripts/shared_code.sh

# Check if required commands are installed
check_commands jq aws terraform

# Assign the first argument to the variable
BACKEND_PROJECT_DEF_FILE=$1

# Check if the provided common_values.json exists
if [ ! -f "$BACKEND_PROJECT_DEF_FILE" ]; then
    echo "$BACKEND_PROJECT_DEF_FILE not found!"
    exit 1
fi

# Load values from the provided common_values.json
PROJECT_NAME=$(jq -r .project_name "$BACKEND_PROJECT_DEF_FILE")
REGION=$(jq -r .region "$BACKEND_PROJECT_DEF_FILE")
BUCKET_NAME=$(jq -r .bucket_name "$BACKEND_PROJECT_DEF_FILE")
DYNAMODB_TABLE=$(jq -r .dynamodb_table "$BACKEND_PROJECT_DEF_FILE")
JIRA_TICKET=$(jq -r .jira_ticket "$BACKEND_PROJECT_DEF_FILE")
ENVIRONMENT=$(jq -r .environment "$BACKEND_PROJECT_DEF_FILE")

# Prompt for test_email with default value
DEFAULT_TEST_EMAIL="mtuszynski+tester@harmonate.com"
read -p "Enter test email [$DEFAULT_TEST_EMAIL]: " TEST_EMAIL
TEST_EMAIL=${TEST_EMAIL:-$DEFAULT_TEST_EMAIL}

# Prompt for initialize_git_repo with default value
DEFAULT_INITIALIZE_GIT_REPO="yes"
read -p "Initialize Local Git repository? [$DEFAULT_INITIALIZE_GIT_REPO]: " INITIALIZE_GIT_REPO
INITIALIZE_GIT_REPO=${INITIALIZE_GIT_REPO:-$DEFAULT_INITIALIZE_GIT_REPO}

# Prompt for create_github_repo with default value
DEFAULT_CREATE_GITHUB_REPO="yes"
read -p "Create Remote GitHub repository? [$DEFAULT_CREATE_GITHUB_REPO]: " CREATE_GITHUB_REPO
CREATE_GITHUB_REPO=${CREATE_GITHUB_REPO:-$DEFAULT_CREATE_GITHUB_REPO}

# Prompt for initial commit message with default value
DEFAULT_INITIAL_COMMIT_MESSAGE="Initial commit"
read -p "Enter initial commit message [$DEFAULT_INITIAL_COMMIT_MESSAGE]: " INITIAL_COMMIT_MESSAGE
INITIAL_COMMIT_MESSAGE=${INITIAL_COMMIT_MESSAGE:-$DEFAULT_INITIAL_COMMIT_MESSAGE}

# Prompt for Terraform Version
DEFAULT_TERRAFORM_VERSION="1.8.5"
read -p "Enter Terraform Version [$DEFAULT_TERRAFORM_VERSION]: " TERRAFORM_VERSION
TERRAFORM_VERSION=${TERRAFORM_VERSION:-$DEFAULT_TERRAFORM_VERSION}

# Define the template directory and the target output directory
TEMPLATE_DIR="/Users/mpt/work/code/terraform-template"
OUTPUT_DIR="/Users/mpt/work/code"

# Run Cookiecutter with pre-defined values
/Users/mpt/.local/bin/cookiecutter $TEMPLATE_DIR --no-input \
    -f project_name=$PROJECT_NAME \
    -f project_slug=$PROJECT_NAME \
    -f region=$REGION \
    -f bucket_name=$BUCKET_NAME \
    -f dynamodb_table=$DYNAMODB_TABLE \
    -f jira_ticket=$JIRA_TICKET \
    -f environment=$ENVIRONMENT \
    -f test_email=$TEST_EMAIL \
    -f initialize_git_repo=$INITIALIZE_GIT_REPO \
    -f create_github_repo=$CREATE_GITHUB_REPO \
    -f repo_name=$PROJECT_NAME \
    -f initial_commit_message="$INITIAL_COMMIT_MESSAGE" \
    -f terraform_version=$TERRAFORM_VERSION \
    -o $OUTPUT_DIR

# Change to the project directory
cd $OUTPUT_DIR/$PROJECT_NAME

# Create a .localawsenv with AWS_PROFILE and AWS_REGION
echo "AWS_PROFILE=$PROJECT_NAME" > .localawsenv
echo "AWS_REGION=$REGION" >> .localawsenv

# Intialize Terraform with the remote backend
terraform init

# Initial Terraform Workspace by environment
terraform workspace new $ENVIRONMENT