Feature: Lambda tests

  Scenario: Cloudwatch is disabled
    Given I have aws_cloudwatch_log_group defined
    Then it must contain name
    And its value must not match the ".*test-function" regex

  Scenario: XRay is enabled
    Given I have aws_iam_role_policy_attachment defined
    When its policy_arn is "arn:aws:iam::aws:policy/service-role/AWSXrayWriteOnlyAccess"
    Then it must contain role
    And its value must match the ".*test-function" regex
