Feature: Lambda tests

  Scenario: Lambda function is created
    Given I have aws_lambda_function defined
    Then it must contain function_name
    And its value must match the "test-function" regex
