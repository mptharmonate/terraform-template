terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "{{ cookiecutter.bucket_name }}"
    key            = "{{ cookiecutter.environment }}/{{ cookiecutter.project_name }}-remote-state.tfstate"
    region         = "{{ cookiecutter.region }}"
    dynamodb_table = "{{ cookiecutter.dynamodb_table }}"
    encrypt        = true
  }
}

locals {
  common_tags = {
    Name        = var.project_name
    Environment = var.environment
    JiraTicket  = var.jira_ticket
  }
  error_alert_list = nonsensitive(split(",", data.aws_ssm_parameter.error_alert_list.value))
  info_alert_list  = nonsensitive(split(",", data.aws_ssm_parameter.info_alert_list.value))
  test_email       = var.test_email
}

provider "aws" {
  region = var.region

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = false

  default_tags {
    tags = local.common_tags
  }
}
