# TODO: Define the output variable for the lambda function.
output "terraform_aws_role_output" {
  value = aws_iam_role.iam_for_lambda.name
}

output "terraform_aws_role_arn_output" {
  value = aws_iam_role.iam_for_lambda.arn
}