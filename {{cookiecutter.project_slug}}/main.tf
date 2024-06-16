# Define the current AWS caller identity
data "aws_caller_identity" "current" {}

# Retrieve the SSM parameter for the error alert list
data "aws_ssm_parameter" "error_alert_list" {
  name = "/sns/lists/${local.environment}/error_alert_list"
}

# Retrieve the SSM parameter for the info alert list
data "aws_ssm_parameter" "info_alert_list" {
  name = "/sns/lists/${local.environment}/info_alert_list"
}

locals {
  common_tags = {
    Name        = var.project_name
    Environment = local.environment
    JiraTicket  = var.jira_ticket
  }
  error_alert_list = nonsensitive(split(",", data.aws_ssm_parameter.error_alert_list.value))
  info_alert_list  = nonsensitive(split(",", data.aws_ssm_parameter.info_alert_list.value))
  test_email       = var.test_email
  environment      = terraform.workspace
  region           = var.region
}
