provider "aws" {
    region = var.region
    shared_credentials_files = ["../credential_file/credentials"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "udacity_lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "udacity_lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging"
  policy      = data.aws_iam_policy_document.udacity_lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "udacity_lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.udacity_lambda_logging.arn
}

data "archive_file" "archive_lambda" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda_function.zip"
}

resource "aws_cloudwatch_log_group" "udacity_log_group" {
  name              = "/aws/lambda/${var.lambda_udacity_log_group}"
  retention_in_days = 14
} 

resource "aws_lambda_function" "udacity_lambda" {
  filename      = "greet_lambda_function.zip"
  function_name = "greet_lambda_handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
  source_code_hash = data.archive_file.archive_lambda.output_base64sha256

  runtime = "python3.8"

  logging_config {
    log_format = "Text"
  }

  depends_on = [
    aws_iam_role_policy_attachment.udacity_lambda_logs,
    aws_cloudwatch_log_group.udacity_log_group,
  ]
}
