/*terraform {
  experiments = [variable_validation]
}*/

module "labels" {
  source  = "cloudposse/label/terraform"
  version = "0.5.0"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name
  tags      = var.tags
}

data "aws_region" "this" {}

data "aws_caller_identity" "this" {}

locals {
  function_name = var.disable_label_function_name_prefix ? var.function_name : "${module.labels.id}-${var.function_name}"
}

// package

data "archive_file" "this" {
  type        = "zip"
  output_path = "${module.labels.id}-${var.function_name}.zip"
  source_dir  = var.lambda_code_dir
}

// lambda

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.include_region ? "${local.function_name}-${data.aws_region.this.name}" : local.function_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = module.labels.tags
}

resource "aws_lambda_function" "this" {
  function_name = local.function_name
  description   = var.description

  memory_size = var.memory_size
  runtime     = var.runtime

  role                           = aws_iam_role.this.arn
  handler                        = var.handler
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.timeout
  kms_key_arn                    = var.kms_key_arn
  publish                        = var.publish_lambda

  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.enable_tracing ? [true] : []
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  tags = module.labels.tags
}

// X-Ray and cloudwatch

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  count      = var.tracing_mode != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.cloudwatch_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_arn
  tags              = module.labels.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_upload_permission" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// SSM

data "aws_iam_policy_document" "ssm_policy_document" {
  count = length(var.ssm_parameter_names)

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:GetParameterHistory"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:parameter/${element(var.ssm_parameter_names, count.index)}",
    ]
  }

}

resource "aws_iam_policy" "ssm_policy" {
  count       = length(var.ssm_parameter_names)
  name        = "${aws_lambda_function.this.function_name}-ssm-${count.index}-${data.aws_region.this.name}"
  description = "Provides minimum Parameter Store permissions for ${aws_lambda_function.this.function_name}."
  policy      = data.aws_iam_policy_document.ssm_policy_document[count.index].json
}


resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  count      = length(var.ssm_parameter_names)
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ssm_policy[count.index].arn
}

// KMS

data "aws_iam_policy_document" "kms_policy_document" {
  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      var.kms_key_arn,
    ]
  }
}

resource "aws_iam_policy" "kms_policy" {
  count       = var.kms_key_arn != "" ? 1 : 0
  name        = "${aws_lambda_function.this.function_name}-kms-${data.aws_region.this.name}"
  description = "Provides minimum KMS permissions for ${aws_lambda_function.this.function_name}."
  policy      = data.aws_iam_policy_document.kms_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  count      = var.kms_key_arn != "" ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.kms_policy[count.index].arn
}

// S3 policies are not part of this module. Module outputs lambda role name to enable attachment of additional policies, including S3

// VPC

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count      = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}