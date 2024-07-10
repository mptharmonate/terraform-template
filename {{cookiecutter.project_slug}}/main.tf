# Define the current AWS caller identity
data "aws_caller_identity" "current" {}

resource "aws_ssm_parameter" "error_alert_list" {
  name        = "/sns/lists/${local.environment}/${var.project_name}/error_alert_list"
  type        = "String"
  value       = var.error_alert_list
  description = "SSM parameter for error alert list"
}

resource "aws_ssm_parameter" "info_alert_list" {
  name        = "/sns/lists/${local.environment}/${var.project_name}/info_alert_list"
  type        = "String"
  value       = var.info_alert_list
  description = "SSM parameter for info alert list"
}

locals {
  common_tags = {
    Name        = var.project_name
    Environment = local.environment
    JiraTicket  = var.jira_ticket
  }
  error_alert_list = nonsensitive(split(",", aws_ssm_parameter.error_alert_list.value))
  info_alert_list  = nonsensitive(split(",", aws_ssm_parameter.info_alert_list.value))
  test_email       = var.test_email
  environment      = terraform.workspace
  region           = var.region
}
