terraform {
  required_version = "~> 0.12.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "v2.30.0"
  region  = var.region
}

module "this" {
  source          = "../../.."
  namespace       = "adaptavist-terraform"
  stage           = "integration"
  function_name   = var.function_name
  description     = "test hello world lambda"
  lambda_code_dir = "../src"
  handler         = "main.handler"
  runtime         = "nodejs10.x"
}

