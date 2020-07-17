Feature: Lambda tests

  Scenario: Lambda function is created
    Given I have aws_lambda_function defined
    Then it must contain function_name
    And its value must match the ".*test-function" regex


  Scenario: Lambda function has source code
    Given I have aws_lambda_function defined
    Then it must contain filename

  Scenario: Lambda role is created
    Given I have aws_iam_role defined
    Then it must contain name
    And its value must match the ".*test-function" regex

  Scenario: Cloudwatch is enabled
    Given I have aws_iam_role_policy_attachment defined
    When its policy_arn is "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    Then it must contain role
    And its value must match the ".*test-function" regex

  Scenario: Cloudwatch log group is defined
    Given I have aws_cloudwatch_log_group defined
    Then it must contain name
    And its value must match the ".*test-function" regex