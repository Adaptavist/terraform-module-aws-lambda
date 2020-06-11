# Lambda Function
output "lambda_arn" {
  description = "The ARN of the lambda lunction"
  value       = element(concat(aws_lambda_function.this.*.arn, [""]), 0)
}

output "lambda_invoke_arn" {
  description = "The invoke ARN of the lambda function"
  value       = element(concat(aws_lambda_function.this.*.invoke_arn, [""]), 0)
}

output "lambda_qualified_arn" {
  description = "The ARN identifying lambda function version"
  value       = element(concat(aws_lambda_function.this.*.qualified_arn, [""]), 0)
}

output "lambda_version" {
  description = "Latest published version of lambda function"
  value       = element(concat(aws_lambda_function.this.*.version, [""]), 0)
}

output "lambda_last_modified" {
  description = "The date lambda function resource was last modified"
  value       = element(concat(aws_lambda_function.this.*.last_modified, [""]), 0)
}

output "lambda_kms_key_arn" {
  description = "The ARN for the KMS encryption key of lambda function"
  value       = element(concat(aws_lambda_function.this.*.kms_key_arn, [""]), 0)
}

output "lambda_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = element(concat(aws_lambda_function.this.*.source_code_hash, [""]), 0)
}

output "lambda_source_code_size" {
  description = "The size in bytes of the function .zip file"
  value       = element(concat(aws_lambda_function.this.*.source_code_size, [""]), 0)
}

# IAM Role
output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the lambda function"
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "lambda_role_name" {
  description = "The ARN of the IAM role created for the lambda function"
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}


