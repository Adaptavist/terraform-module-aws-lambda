/*terraform {
  experiments = [variable_validation]
}*/


module "labels" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name
  tags      = var.tags
}

data "aws_caller_identity" "this" {}

locals {
  function_name = var.disable_label_function_name_prefix ? var.function_name : "${module.labels.id}-${var.function_name}"
  role_name     = var.include_region ? "${local.function_name}-${var.aws_region}" : local.function_name
}

// package

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/${module.labels.id}-${var.function_name}.zip"
  source_dir  = var.lambda_code_dir
}

// lambda

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_policy_principles
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = module.labels.tags
}


resource "aws_lambda_function" "this" {
  #checkov:skip=CKV_AWS_50:X-ray tracing not enforced in Adaptavist
  #checkov:skip=CKV_AWS_115:Lambda dead letter queue not enforced in Adaptavist
  #checkov:skip=CKV_AWS_116:Lambda dead letter queue not enforced in Adaptavist
  #checkov:skip=CKV_AWS_117:Lambdas in the default VPC  security groups are hardened appropriately

  function_name = local.function_name
  description   = var.description

  memory_size = var.memory_size
  runtime     = var.runtime

  role                           = aws_iam_role.this.arn
  handler                        = var.handler
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.timeout
  kms_key_arn                    = var.kms_key_arn == "" ? join("" , aws_kms_key.kms_key[*].arn) : var.kms_key_arn
  publish                        = var.publish_lambda
  layers                         = var.layers

  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  code_signing_config_arn = aws_lambda_code_signing_config.code_signinig_config.arn

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

  dead_letter_config {
   target_arn = aws_sqs_queue.dlq_sqs_queue.arn
 }

  tags = module.labels.tags
}

// X-Ray and cloudwatch



resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  count      = var.tracing_mode != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.cloudwatch_retention_in_days
  kms_key_id        = var.kms_key_arn == "" ? join("" , aws_kms_key.kms_key[*].arn) : var.kms_key_arn
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
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.this.account_id}:parameter/${element(var.ssm_parameter_names, count.index)}",
    ]
  }

}

resource "aws_iam_policy" "ssm_policy" {
  count       = length(var.ssm_parameter_names)
  name        = "${aws_lambda_function.this.function_name}-ssm-${count.index}-${var.aws_region}"
  description = "Provides minimum Parameter Store permissions for ${aws_lambda_function.this.function_name}."
  policy      = data.aws_iam_policy_document.ssm_policy_document[count.index].json
}


resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  count      = length(var.ssm_parameter_names)
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ssm_policy[count.index].arn
}

// KMS

resource "aws_kms_key" "kms_key" {
  count  = var.kms_key_arn == "" ? 1 : 0
  policy      = data.aws_iam_policy_document.kms_policy.json
  tags        = var.tags
  enable_key_rotation    = true
}

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
  name        = "${aws_lambda_function.this.function_name}-kms-${var.aws_region}"
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


// SQS DLQ

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


resource "aws_sqs_queue" "dlq_sqs_queue" {
  name                      = "${local.function_name}-dlq.fifo"
  kms_master_key_id         = var.kms_key_arn == "" ? join("" , aws_kms_key.kms_key[*].arn) : var.kms_key_arn
  fifo_queue                = true
  deduplication_scope       = "messageGroup"
  fifo_throughput_limit     = "perMessageGroupId"
  message_retention_seconds = 1209600 # 14 days which is the max
  policy                    = data.aws_iam_policy_document.dlq_sqs_policy.json

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.function_name}.fifo"] // We have to build arn like this or we get a cycle
  })

  tags = var.tags
}


# resource "aws_kms_key" "kms_key" {
#   description = "Key used for the SQS queue ${local.function_name}"
#   policy      = data.aws_iam_policy_document.kms_policy.json
#   tags        = var.tags
#   enable_key_rotation    = true

# }

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${local.function_name}"
  target_key_id = var.kms_key_arn == "" ? join("" , aws_kms_key.kms_key[*].arn) : var.kms_key_arn
}

resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name                = "${local.function_name}-dlq"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "ApproximateNumberOfMessagesVisible"
  namespace                 = "AWS/SQS"
  period                    = "60"
  statistic                 = "Sum"
  alarm_actions             = []
  threshold                 = "1"
  alarm_description         = "This metric monitors DLQ length"
  insufficient_data_actions = []
  tags                      = var.tags


  dimensions = {
    QueueName = aws_sqs_queue.dlq_sqs_queue.name
  }
}
// code signing

resource "aws_lambda_code_signing_config" "code_signinig_config" {
  allowed_publishers {
    signing_profile_version_arns = length(var.lambda_code_signing_profile_arns) == 0 ? [join("", aws_signer_signing_profile.signing_profile[*].arn)] : var.lambda_code_signing_profile_arns
  }
}

resource "aws_signer_signing_profile" "signing_profile" {
  count = length(var.lambda_code_signing_profile_arns) == 0 ? 1 : 0
  platform_id = "AWSLambda-SHA384-ECDSA"
}


data "aws_iam_policy_document" "sqs_policy" {

  statement {
    sid    = "lambda_receive"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:Get*",
      "sqs:Delete*"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    resources = ["*"]
  }

  statement {
    sid    = "lambda_send_message"
    effect = "Allow"
    actions = [
      "sqs:SendMessage"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "dlq_sqs_policy" {

  statement {
    sid    = "lambda_receive"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms_policy" {

  statement {
    sid     = "s3_access"
    effect  = "Allow"
    actions = ["kms:*"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    resources = ["*"]
  }

  statement {
    sid     = "account_access"
    effect  = "Allow"
    actions = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
}


