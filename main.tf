resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}"

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
  name = "${var.lambda_name}"
  role = "${aws_iam_role.lambda.name}"

  policy = "${var.iam_policy_document}"
}

resource "aws_lambda_function" "lambda" {
  runtime          = "${var.runtime}"
  filename         = "${var.lambda_zipfile}"
  function_name    = "${var.lambda_name}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  source_code_hash = "${var.source_code_hash}"
  count            = "${var.enabled}"
  timeout          = "${var.timeout}"
}

resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
  count         = "${var.enabled}"
}

resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "${var.lambda_name}"
  schedule_expression = "${var.schedule_expression}"
  count               = "${var.enabled}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  target_id = "${var.lambda_name}"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
  count     = "${var.enabled}"
}
