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
    "Avst:Project"      = "testproject"
    "Avst:BusinessUnit" = "testbu"
    "Avst:CostCenter"   = "testCC"
    "Avst:Team"         = "testteam"
    "Avst:Stage:Name"   = "teststage"
    "Avst:Stage:Type"   = "integration"
  }
  function_name   = "test-function"
  description     = "test hello world lambda"
  lambda_code_dir = "../src"
  handler         = "main.handler"
  runtime         = "nodejs10.x"
  timeout         = 3
}

