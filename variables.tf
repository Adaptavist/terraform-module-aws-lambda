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
  type = map(string)
}

variable "include_region" {
  type        = bool
  default     = false
  description = "If set to true the current providers region will be appended to any global AWS resources such as IAM roles"
}

// lambda

variable "function_name" {
  description = "A unique name for the lambda function."
  type        = string
}

variable "disable_label_function_name_prefix" {
  description = "Indicates if prefixing of the lambda function name should be disabled. Defaults to false"
  type        = bool
  default     = false
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

variable "publish_lambda" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

// TODO do variable validation once we move to TF 0.13
variable "runtime" {
  description = "The runtime environment for the Lambda function. Valid Values: nodejs10.x | nodejs12.x | java8 | java11 | python2.7 | python3.6 | python3.7 | python3.8 | dotnetcore2.1 | dotnetcore3.1 | go1.x | ruby2.5 | ruby2.7 | provided"
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

variable "assume_role_policy_principles" {
  description = "Principles which can assume the lambdas role."
  type        = list(string)
  default = [
    "lambda.amazonaws.com",
    "edgelambda.amazonaws.com"
  ]
}

// Tracing

variable "enable_tracing" {
  description = "Enable tracing of requests. If tracing is enabled, tracing mode needs to be specified."
  type        = bool
  default     = false
}


variable "tracing_mode" {
  description = "Required if tracing is enabled. Possible values: PassThrough or Active. See https://www.terraform.io/docs/providers/aws/r/lambda_function.html#mode"
  type        = string
  default     = null
  /*validation {
    condition     = var.tracing_mode != null ? (var.tracing_mode == "PassThrough" || var.tracing_mode == "Active") : true
    error_message = "Tracing mode is mandatory if tracing is enabled. Possible values are PassThrough or Active."
  }*/
}

// Cloudwatch

variable "enable_cloudwatch_logs" {
  description = "Enable cloudwatch logs"
  type        = bool
  default     = true
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
