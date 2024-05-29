#!/bin/bash

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Check if the argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 path_to_common_values.json"
    exit 1
fi

# Assign the first argument to the variable
COMMON_VALUES_FILE=$1

# Check if the provided common_values.json exists
if [ ! -f "$COMMON_VALUES_FILE" ]; then
    echo "$COMMON_VALUES_FILE not found!"
    exit 1
fi

# Load values from the provided common_values.json
PROJECT_NAME=$(jq -r .project_name "$COMMON_VALUES_FILE")
REGION=$(jq -r .region "$COMMON_VALUES_FILE")
BUCKET_NAME=$(jq -r .bucket_name "$COMMON_VALUES_FILE")
DYNAMODB_TABLE=$(jq -r .dynamodb_table "$COMMON_VALUES_FILE")
JIRA_TICKET=$(jq -r .jira_ticket "$COMMON_VALUES_FILE")
ENVIRONMENT=$(jq -r .environment "$COMMON_VALUES_FILE")

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

# Define the template directory and the target output directory
TEMPLATE_DIR="/Users/mpt/work/code/terraform-template"

# Run Cookiecutter with pre-defined values
cookiecutter $TEMPLATE_DIR --no-input \
    -f project_name=$PROJECT_NAME \
    -f region=$REGION \
    -f bucket_name=$BUCKET_NAME \
    -f dynamodb_table=$DYNAMODB_TABLE \
    -f jira_ticket=$JIRA_TICKET \
    -f environment=$ENVIRONMENT \
    -f test_email=$TEST_EMAIL \
    -f initialize_git_repo=$INITIALIZE_GIT_REPO \
    -f create_github_repo=$CREATE_GITHUB_REPO \
    -f initial_commit_message="$INITIAL_COMMIT_MESSAGE"