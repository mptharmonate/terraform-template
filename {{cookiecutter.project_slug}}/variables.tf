variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "jira_ticket" {
  description = "Jira Ticket"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "test_email" {
  description = "Test Email"
  type        = string
}

variable "ignore_changes_on_destroy" {
  description = "List of attributes to ignore changes"
  type        = bool
}