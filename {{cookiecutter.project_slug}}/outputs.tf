# Output common tags for SSM parameter labeling
output "common_tags" {
  description = "Common tags to apply to all resources"
  value       = local.common_tags
}

output "aws_region" {
  value = var.region
}