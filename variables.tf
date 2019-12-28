variable "lambda_name" {
}

variable "runtime" {
}

variable "lambda_zipfile" {
}

variable "source_code_hash" {
}

variable "handler" {
}

variable "schedule_expression" {
}

variable "iam_policy_document" {
}

variable "enabled" {
  default = true
}

variable "timeout" {
  default = 3
}

variable "vpc_config" {
  type = object({subnet_ids = list(string), security_group_ids = list(string)})
  default = null
}
