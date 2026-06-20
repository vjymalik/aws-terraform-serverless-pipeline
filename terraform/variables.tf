variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Name prefix used for all resources"
  type        = string
  default     = "serverless-data-pipeline"
}

variable "alert_email" {
  description = "Email address to receive SNS failure alerts"
  type        = string
}
