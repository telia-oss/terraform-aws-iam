terraform {
  required_version = "~> 0.14"


  # backend "s3" {
  #   key            = "terraform-modules/development/terraform-module-template/default.tfstate"
  #   bucket         = "<test-account-id>-terraform-state"
  #   dynamodb_table = "<test-account-id>-terraform-state"
  #   acl            = "bucket-owner-full-control"
  #   encrypt        = "true"
  #   kms_key_id     = "<kms-key-id>"
  #   region         = "eu-west-1"
  # }
}

provider "aws" {
  #version = "3.27.0" This is moved into required_providers block on terraform 0.14
  region = "eu-west-1"
  #allowed_account_ids = ["<test-account-id>"]
}

data "aws_caller_identity" "current" {}

module "admin" {
  source  = "../../modules/user"
  name    = "first.last.admin"
  path    = "/admins/"
  keybase = "rickardlofstrom"
}

module "user_policy" {
  source = "../../modules/user-policies"
}

module "developer" {
  source = "../../modules/user"

  name    = "first.last.developer"
  path    = "/developer/"
  keybase = "rickardlofstrom"
}

module "user_roles" {
  source                = "../../modules/user-roles"
  trusted_account       = data.aws_caller_identity.current.account_id
  view_only_role_suffix = "read-only"
  admin_role_suffix     = "administrator"

  admin_users = [
    "admins/first.last.admin",
  ]

  view_only_users = [
    "developer/first.last.developer",
  ]
}

module "machine_role" {
  source = "../../modules/machine-role"
  name   = "machine-user-role"

  trusted_principals = [
    aws_iam_role.example_lambda_role.arn,
  ]
}

resource "aws_iam_role" "example_lambda_role" {
  name = "example_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "basic-exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.example_lambda_role.name
}

resource "aws_lambda_function" "example" {
  function_name = "example-lambda-function"
  handler       = "lambda.handler"
  role          = aws_iam_role.example_lambda_role.arn
  runtime       = "nodejs14.x"
  filename      = "lambda.zip"
}
