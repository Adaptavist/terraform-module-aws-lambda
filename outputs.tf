# Lambda Function
output "lambda_name" {
  description = "The name of the lambda function"
  value       = aws_lambda_function.this.function_name
}

output "lambda_arn" {
  description = "The ARN of the lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  description = "The invoke ARN of the lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_qualified_arn" {
  description = "The ARN identifying lambda function version"
  value       = aws_lambda_function.this.qualified_arn
}

output "lambda_version" {
  description = "Latest published version of lambda function"
  value       = aws_lambda_function.this.version
}

output "lambda_last_modified" {
  description = "The date lambda function resource was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "lambda_kms_key_arn" {
  description = "The ARN for the KMS encryption key of lambda function"
  value       = aws_lambda_function.this.kms_key_arn
}

output "lambda_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = aws_lambda_function.this.source_code_hash
}

output "lambda_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = aws_lambda_function.this.source_code_size
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the lambda function"
  value       = aws_iam_role.this.arn
}

output "lambda_role_name" {
  description = "The Name of the IAM role created for the lambda function"
  value       = aws_iam_role.this.name
}

output "cloudwatch_log_group_arn" {
  description = "The ARN of the cloudwatch log group"
  value       = join("", aws_cloudwatch_log_group.cloudwatch_log_group.*.arn)
}


