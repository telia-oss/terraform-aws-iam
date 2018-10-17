# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
module "role" {
  source = "../role"

  prefix          = "${var.prefix}-admin"
  trusted_account = "${var.trusted_account}"
  mfa_window      = "${var.mfa_window}"
  users           = "${var.users}"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${module.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
