terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "{{cookiecutter.bucket_name}}"
    key            = "{{cookiecutter.environment}}/{{cookiecutter.project_name}}-remote-state.tfstate"
    region         = "{{cookiecutter.region}}"
    dynamodb_table = "{{cookiecutter.dynamodb_table}}"
    encrypt        = true
  }
}

provider "null" {}

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
