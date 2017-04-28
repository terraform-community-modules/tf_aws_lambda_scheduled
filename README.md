# Scheduled AWS Lambda function
=============================

This module can be used to deploy an AWS Lambda function which is scheduled to run on a recurring basis.

Module Input Variables
----------------------

- `lambda_name` - Unique name for Lambda function
- `runtime` - A [valid](http://docs.aws.amazon.com/cli/latest/reference/lambda/create-function.html#options) Lambda runtime environment
- `lambda_zipfile` - path to zip archive containing Lambda function
- `source_code_hash` - the base64 encoded sha256 hash of the archive file - see TF [archive file provider](https://www.terraform.io/docs/providers/archive/d/archive_file.html)
- `handler` - the entrypoint into your Lambda function, in the form of `filename.function_name`
- `schedule_expression` - a [valid rate or cron expression](http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html)
- `iam_policy_document` - a valid IAM policy document used for the Lambda's [execution role](http://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#lambda-intro-execution-role)
- `timeout` - (optional) the amount of time your Lambda Function has to run in seconds. Defaults to 3. See [Limits](https://docs.aws.amazon.com/lambda/latest/dg/limits.html)
- `enabled` - boolean expression. If false, the lambda function and the cloudwatch schedule are not set. Defaults to `true`.

Usage 
-----

```js
data "aws_iam_policy_document" "create_snaps" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeVolumes",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
    ]

    resources = [
      "*",
    ]
  }
}

data "archive_file" "myfunction" {
  type        = "zip"
  source_file = "/valid/path/to/myfunction.py"
  output_path = "/valid/path/to/myfunction.zip"
}

module "lambda_scheduled" {
  source              = "github.com/terraform-community-modules/tf_aws_lambda_scheduled"
  lambda_name         = "my_scheduled_lambda"
  runtime             = "python2.7"
  lambda_zipfile      = "/valid/path/to/myfunction.zip"
  source_code_hash    = "${data.archive_file.myfunction.output_base64sha256}"
  handler             = "myfunction.handler"
  schedule_expression = "rate(1 day)"
  iam_policy_document = "${data.aws_iam_policy_document.create_snaps.json}"
}
```

Outputs
-------
- `lambda_arn` - ARN for the created Lambda function

Author
------
Created and maintained by [Shayne Clausson](https://github.com/sclausson)
