# Output common tags for SSM parameter labeling
output "common_tags" {
  description = "Common tags to apply to all resources"
  value       = local.common_tags
}

output "ssm_parameter_names" {
  value = [
    data.aws_ssm_parameter.error_alert_list.name,
    data.aws_ssm_parameter.info_alert_list.name
  ]
}

output "aws_region" {
  value = var.region
}