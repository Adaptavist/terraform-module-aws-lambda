# AWS Lambda

This module creates a set of AWS Lambda resources including the packaging of function code. 

- AWS Lambda function 
- AWS Lambda IAM role
- (optional) SSM IAM policy to allow the function access to a specified set of SSM parameters
- (optional) KMS IAM policy to allow the function access to the KMS key used for decryption
- (optional) VPC attachment IAM policy to allow the function access to VPC resources
- (optional) Adds X-Ray write only policy if tracing is enabled

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assume\_role\_policy\_principles | Princliples which can assume the lambdas role. | `list(string)` | <pre>[<br>  "lambda.amazonaws.com",<br>  "edgelambda.amazonaws.com"<br>]</pre> | no |
| cloudwatch\_kms\_key\_arn | The ARN of the KMS Key to use when encrypting log data | `string` | `null` | no |
| cloudwatch\_retention\_in\_days | The number of days you want to retain log events in lambda's log group | `number` | `14` | no |
| description | A description of the lambda function. | `any` | n/a | yes |
| disable\_label\_function\_name\_prefix | Indicates if prefixing of the lambda function name should be disabled. Defaults to false | `bool` | `false` | no |
| enable\_cloudwatch\_logs | Enable cloudwatch logs | `bool` | `true` | no |
| enable\_tracing | Enable tracing of requests. If tracing is enabled, tracing mode needs to be specified. | `bool` | `false` | no |
| environment\_variables | Environment variables | `map(string)` | `{}` | no |
| external\_lambda\_hash | n/a | `string` | `""` | no |
| function\_name | A unique name for the lambda function. | `string` | n/a | yes |
| handler | The function entrypoint. | `string` | n/a | yes |
| include\_region | If set to true the current providers region will be appended to any global AWS resources such as IAM roles | `bool` | `false` | no |
| kms\_key\_arn | KMS key used for decryption | `string` | `""` | no |
| lambda\_code\_dir | A directory containing the code that needs to be packaged. | `string` | `"src"` | no |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime | `string` | `"128"` | no |
| name | n/a | `string` | `"function"` | no |
| namespace | n/a | `string` | n/a | yes |
| publish\_lambda | Whether to publish creation/change as new Lambda Function Version. | `bool` | `false` | no |
| reserved\_concurrent\_executions | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `-1` | no |
| runtime | The runtime environment for the Lambda function. Valid Values: nodejs10.x \| nodejs12.x \| java8 \| java11 \| python2.7 \| python3.6 \| python3.7 \| python3.8 \| dotnetcore2.1 \| dotnetcore3.1 \| go1.x \| ruby2.5 \| ruby2.7 \| provided | `string` | n/a | yes |
| ssm\_parameter\_names | Names of SSM parameters that lambda will be able to access | `list(string)` | `[]` | no |
| stage | n/a | `string` | n/a | yes |
| tags | n/a | `map(string)` | n/a | yes |
| timeout | timeout | `any` | n/a | yes |
| tracing\_mode | Required if tracing is enabled. Possible values: PassThrough or Active. See https://www.terraform.io/docs/providers/aws/r/lambda_function.html#mode | `string` | `null` | no |
| vpc\_security\_group\_ids | Allows the function to access VPC (if both 'subnet\_ids' and 'security\_group\_ids' are empty then vpc\_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). | `list(string)` | `[]` | no |
| vpc\_subnet\_ids | Allows the function to access VPC subnets (if both 'subnet\_ids' and 'security\_group\_ids' are empty then vpc\_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). | `list(string)` | `[]` | no |
   

## Outputs

| Name                    | Description                                                       |
| ----------------------- | ----------------------------------------------------------------- |
| lambda_name             | The name of the Lambda Function                                   |
| lambda_arn              | The ARN of the Lambda Function                                    |
| lambda_invoke_arn       | The Invoke ARN of the Lambda Function                             |
| lambda_qualified_arn    | The ARN identifying lambda function version                       |
| lambda_version          | Latest published version of lambda function                       |
| lambda_last_modified    | The date lambda function resource was last modified               |
| lambda_kms_key_arn      | The ARN for the KMS encryption key of lambda function             |
| lambda_source_code_hash | Base64-encoded representation of raw SHA-256 sum of the zip file  |
| lambda_source_code_size | The size in bytes of the function .zip file                       |
| lambda_role_arn         | The ARN of the IAM role created for the lambda function           |
| lambda_role_name        | The name of the IAM role created for the lambda function          |
| cloudwatch_log_group_arn| The ARN of the cloudwatch log group                               |
