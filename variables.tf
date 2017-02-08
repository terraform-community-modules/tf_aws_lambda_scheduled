variable "lambda_name" {}

variable "runtime" {}

variable "lambda_zipfile" {}

variable "source_code_hash" {}

variable "handler" {}

variable "schedule_expression" {}

variable "iam_policy_document" {}

variable "enabled" {
  default = true
}
