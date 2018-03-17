variable "enabled" {
  type        = "string"
  default     = "true"
  description = "Toggle the creation and destruction of all resources in this module"
}

locals {
  // transform the public `enabled` variable into a count integer
  enabled = "${lower(var.enabled) == "true" ? 1 : 0}"
}

variable "lambda_name" {
  type        = "string"
  description = "Unique name, used as the prefix in all resources created by this module"
}

variable "runtime" {
  type = "string"

  description = <<DESC
Lambda runtime environment
https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html
DESC
}

variable "lambda_zipfile" {
  type = "string"

  description = <<DESC
Path to the lambda function zip file, packaged according to aws specifications
https://docs.aws.amazon.com/lambda/latest/dg/deployment-package-v2.html
DESC
}

variable "source_code_hash" {
  type        = "string"
  description = "The base64 encoded sha256 hash of the zipfile provided to `lambda_zipfile`"
}

variable "handler" {
  type = "string"

  description = <<DESC
Lambda Function handler, the entrypoint for your function
https://docs.aws.amazon.com/lambda/latest/dg/programming-model-v2.html
DESC
}

variable "schedule_expression" {
  type = "string"

  description = <<DESC
CloudWatch Schedule Expression
http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html
DESC
}

variable "iam_policy_document" {
  type = "string"

  description = <<DESC
JSON IAM Policy to attach to the Lambda Role
http://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#lambda-intro-execution-role
DESC
}

variable "timeout" {
  type    = "string"
  default = "3"

  description = <<DESC
Lambda function timeout, defaults to 3
https://docs.aws.amazon.com/lambda/latest/dg/limits.html
DESC
}
