output "lambda_arn" {
  value = "${element(aws_lambda_function.lambda.*.arn, 0)}"
}

output "role_arn" {
  value = "${element(aws_iam_role.lambda.arn, 0)}"
}

output "role_name" {
  value = "${element(aws_iam_role.lambda.name, 0)}"
}
