provider "aws" {
  region = "eu-west-1"
}

module "user" {
  source = "../../modules/user"

  username = "first.last"
  keybase  = "itsdalmo"
}

module "role" {
  source           = "../../modules/role"
  prefix           = "example-project-developer"
  trusted_account  = "<user-account>"
  role_description = "example role created to show iam/role module in use"

  users = [
    "first.last",
  ]
}

module "developer" {
  source          = "../../modules/developer"
  prefix          = "example-project"
  trusted_account = "<user-account>"

  users = [
    "first.last",
  ]
}

module "admin" {
  source          = "../../modules/admin"
  prefix          = "example-project"
  trusted_account = "<user-account>"

  users = [
    "first.last",
  ]
}
