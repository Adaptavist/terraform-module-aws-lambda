terraform {
  required_version = "~> 0.12.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "v2.30.0"
  region  = "eu-west-1"
}

module "this" {
  source    = "../../.."
  namespace = "adaptavist-terraform"
  stage     = "stg"
  name      = "test"
  tags = {
    Product      = "test"
    BusinessUnit = "test"
    Component    = "test"
  }
  function_name          = "test-function"
  description            = "test hello world lambda"
  lambda_code_dir        = "../src"
  handler                = "main.handler"
  runtime                = "nodejs10.x"
  tracing_mode           = "Active"
  timeout                = 3
  enable_cloudwatch_logs = false
}

