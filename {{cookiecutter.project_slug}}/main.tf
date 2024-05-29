# Define the current AWS caller identity
data "aws_caller_identity" "current" {}

# Retrieve the SSM parameter for the error alert list
data "aws_ssm_parameter" "error_alert_list" {
  name = "/sns/lists/error_alert_list"
}

# Retrieve the SSM parameter for the info alert list
data "aws_ssm_parameter" "info_alert_list" {
  name = "/sns/lists/info_alert_list"
}