variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "{{ cookiecutter.project_name }}"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "{{ cookiecutter.region }}"
}

variable "jira_ticket" {
  description = "Jira Ticket"
  type        = string
  default     = "{{ cookiecutter.jira_ticket }}"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "{{ cookiecutter.environment }}"
}

variable "test_email" {
  description = "Test Email"
  type        = string
  default     = "{{ cookiecutter.test_email }}"
}

variable "ignore_changes_on_destroy" {
  description = "List of attributes to ignore changes"
  type        = bool
}