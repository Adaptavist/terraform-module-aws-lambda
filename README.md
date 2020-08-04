# AWS Lambda

This module creates a set of AWS Lambda resources including the packaging of function code. 

- AWS Lambda function 
- AWS Lambda IAM role
- (optional) SSM IAM policy to allow the function access to a specified set of SSM parameters
- (optional) KMS IAM policy to allow the function access to the KMS key used for decryption
- (optional) VPC attachment IAM policy to allow the function access to VPC resources
- (optional) Adds X-Ray write only policy if tracing is enabled

## Variables

| Name                           | Type    | Default | Required | Description                                                                
| ------------------------------ | ------- | ------- | -------- | -------------------------------------------------------------------------- 
| function_name                  | string  |         | ✓        | A unique name for the lambda function                                      
| description                    | string  |         | ✓        | A description of the lambda function                                       
| lambda_code_dir                | string  |         | ✓        | A directory containing the code that needs to be packaged                  
| handler                        | string  |         | ✓        | The function entrypoint                                                    
| runtime                        | string  |         | ✓        | The runtime environment for the Lambda function. Valid Values: nodejs10.x nodejs12.x java8 java11 python2.7 python3.6 python3.7 python3.8 dotnetcore2.1 dotnetcore3.1 go1.x ruby2.5 ruby2.7 provided                            
| memory_size                    | integer | 128     |          | Amount of memory in MB your Lambda Function can use at runtime             
| reserved_concurrent_executions | string  | -1      |          | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations.
| timeout                        | integer |         | ✓        | timeout                                                                    
| kms_key_arn                    | string  |         |          | KMS key used for decryption                                                
| environment_variables          | map     |         |          | Environment variables
| enable_tracing                 | bool    | false   |          | Enables X-Ray. If true, tracing_mode variable is required
| tracing_mode                   | string  |         |          | Mandatory if tracing is enabled. Possible values: PassThrough or Active. See https://www.terraform.io/docs/providers/aws/r/lambda_function.html#mode
| enable_cloudwatch_logs         | bool    | true    |          | Enable cloudwatch logs
| cloudwatch_retention_in_days   | integer | 14      |          | The number of days you want to retain log events in lambda's log group
| cloudwatch_kms_key_arn         | string  |         |          | The ARN of the KMS Key to use when encrypting log data
| vpc_subnet_ids                 | list    |         |          | Allows the function to access VPC subnets (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details).
| vpc_security_group_ids         | list    |         |          | Allows the function to access VPC (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details).
| ssm_parameter_names            | list    |         |          | Names of SSM parameters that lambda will be able to access
| namespace                      | string  |         | ✓        | Namespace used for labeling resources                  
| name                           | string  |         | ✓        | Name of the module / resources                         
| stage                          | string  |         | ✓        | What staga are the resources for? staging, production? 
| tags                           | map     |         | ✓        | Map of tags to be applied to all resources             

## Outputs

| Name                    | Description                                                       |
| ----------------------- | ----------------------------------------------------------------- |
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
