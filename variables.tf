// labelling

variable "name" {
  type    = string
  default = "function"
}

variable "namespace" {
  type = string
}

variable "stage" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

// lambda

variable "function_name" {
  description = "A unique name for the lambda function."
  type        = string
}

variable "lambda_code_dir" {
  description = "A directory containing the code that needs to be packaged."
  type        = string
  default     = "src"
}

variable "handler" {
  description = "The function entrypoint."
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
}

variable "description" {
  description = "A description of the lambda function."
}
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = "128"
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  default     = -1
}
variable "timeout" {
  description = "timeout"
  default     = 3
}
variable "kms_key_arn" {
  description = "KMS key used for decryption"
  default     = ""
}
variable "environment_variables" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

// Tracing

variable "tracing_mode" {
  description = "Possible values: PassThrough or Active. See https://www.terraform.io/docs/providers/aws/r/lambda_function.html#mode"
  type        = string
  default     = null
}

// Cloudwatch

variable "disable_cloudwatch_logs" {
  description = "Disable cloudwatch logs"
  type        = bool
  default     = false
}

variable "cloudwatch_retention_in_days" {
  description = "The number of days you want to retain log events in lambda's log group"
  type        = number
  default     = 14
}

variable "cloudwatch_kms_key_arn" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

// VPC

variable "vpc_subnet_ids" {
  description = "Allows the function to access VPC subnets (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details)."
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "Allows the function to access VPC (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details)."
  type        = list(string)
  default     = []
}

// SSM

variable "ssm_parameter_names" {
  description = "Names of SSM parameters that lambda will be able to access"
  type        = list(string)
  default     = []
}


