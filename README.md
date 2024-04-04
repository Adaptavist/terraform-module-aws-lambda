# AWS Lambda

This module creates a set of AWS Lambda resources including the packaging of function code. 

- AWS Lambda function 
- AWS Lambda IAM role
- (optional) SSM IAM policy to allow the function access to a specified set of SSM parameters
- (optional) KMS IAM policy to allow the function access to the KMS key used for decryption
- (optional) VPC attachment IAM policy to allow the function access to VPC resources
- (optional) Adds X-Ray write only policy if tracing is enabled

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_xray_write_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_logs_upload_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kms_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_assume_role_policy_principles"></a> [assume\_role\_policy\_principles](#input\_assume\_role\_policy\_principles) | Principles which can assume the lambdas role. | `list(string)` | <pre>[<br>  "lambda.amazonaws.com",<br>  "edgelambda.amazonaws.com"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_cloudwatch_kms_key_arn"></a> [cloudwatch\_kms\_key\_arn](#input\_cloudwatch\_kms\_key\_arn) | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| <a name="input_cloudwatch_retention_in_days"></a> [cloudwatch\_retention\_in\_days](#input\_cloudwatch\_retention\_in\_days) | The number of days you want to retain log events in lambda's log group | `number` | `14` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the lambda function. | `any` | n/a | yes |
| <a name="input_disable_label_function_name_prefix"></a> [disable\_label\_function\_name\_prefix](#input\_disable\_label\_function\_name\_prefix) | Indicates if prefixing of the lambda function name should be disabled. Defaults to false | `bool` | `false` | no |
| <a name="input_enable_cloudwatch_logs"></a> [enable\_cloudwatch\_logs](#input\_enable\_cloudwatch\_logs) | Enable cloudwatch logs | `bool` | `true` | no |
| <a name="input_enable_tracing"></a> [enable\_tracing](#input\_enable\_tracing) | Enable tracing of requests. If tracing is enabled, tracing mode needs to be specified. | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | A unique name for the lambda function. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint. | `string` | n/a | yes |
| <a name="input_include_region"></a> [include\_region](#input\_include\_region) | If set to true the current providers region will be appended to any global AWS resources such as IAM roles | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key used for decryption | `string` | `""` | no |
| <a name="input_lambda_code_dir"></a> [lambda\_code\_dir](#input\_lambda\_code\_dir) | A directory containing the code that needs to be packaged. | `string` | `"src"` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | Expected Layers to attach to the lambda | `list(string)` | `[]` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `string` | `"128"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"function"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_publish_lambda"></a> [publish\_lambda](#input\_publish\_lambda) | Whether to publish creation/change as new Lambda Function Version. | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime environment for the Lambda function. Valid Values: nodejs10.x \| nodejs12.x \| java8 \| java11 \| python2.7 \| python3.6 \| python3.7 \| python3.8 \| dotnetcore2.1 \| dotnetcore3.1 \| go1.x \| ruby2.5 \| ruby2.7 \| provided | `string` | n/a | yes |
| <a name="input_ssm_parameter_names"></a> [ssm\_parameter\_names](#input\_ssm\_parameter\_names) | Names of SSM parameters that lambda will be able to access | `list(string)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | timeout | `any` | n/a | yes |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Required if tracing is enabled. Possible values: PassThrough or Active. See https://www.terraform.io/docs/providers/aws/r/lambda_function.html#mode | `string` | `null` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Allows the function to access VPC (if both 'subnet\_ids' and 'security\_group\_ids' are empty then vpc\_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | Allows the function to access VPC subnets (if both 'subnet\_ids' and 'security\_group\_ids' are empty then vpc\_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | The ARN of the cloudwatch log group |
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | The ARN of the lambda function |
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | The invoke ARN of the lambda function |
| <a name="output_lambda_kms_key_arn"></a> [lambda\_kms\_key\_arn](#output\_lambda\_kms\_key\_arn) | The ARN for the KMS encryption key of lambda function |
| <a name="output_lambda_last_modified"></a> [lambda\_last\_modified](#output\_lambda\_last\_modified) | The date lambda function resource was last modified |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | The name of the lambda function |
| <a name="output_lambda_qualified_arn"></a> [lambda\_qualified\_arn](#output\_lambda\_qualified\_arn) | The ARN identifying lambda function version |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | The ARN of the IAM role created for the lambda function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The Name of the IAM role created for the lambda function |
| <a name="output_lambda_source_code_hash"></a> [lambda\_source\_code\_hash](#output\_lambda\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_lambda_source_code_size"></a> [lambda\_source\_code\_size](#output\_lambda\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_lambda_version"></a> [lambda\_version](#output\_lambda\_version) | Latest published version of lambda function |
