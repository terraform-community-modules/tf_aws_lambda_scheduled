locals {
  enabled_as_count = var.enabled ? 1 : 0
}

resource "aws_iam_role" "lambda" {
  name = var.lambda_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "lambda" {
  name = var.lambda_name
  role = aws_iam_role.lambda.name

  policy = var.iam_policy_document
}

resource "aws_lambda_function" "lambda" {
  runtime          = var.runtime
  filename         = var.lambda_zipfile
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda.arn
  handler          = var.handler
  source_code_hash = var.source_code_hash
  count            = local.enabled_as_count
  timeout          = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }
}

resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[0].arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
  count         = local.enabled_as_count
}

resource "aws_cloudwatch_event_rule" "lambda" {
  name                = var.lambda_name
  schedule_expression = var.schedule_expression
  count               = local.enabled_as_count
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = var.lambda_name
  rule      = aws_cloudwatch_event_rule.lambda[0].name
  arn       = aws_lambda_function.lambda[0].arn
  count     = local.enabled_as_count
}
