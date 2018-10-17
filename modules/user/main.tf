# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

resource "aws_iam_user" "main" {
  name          = "${var.name}"
  path          = "${var.path}"
  force_destroy = "true"
}

resource "aws_iam_user_login_profile" "main" {
  user                    = "${aws_iam_user.main.name}"
  pgp_key                 = "keybase:${var.keybase}"
  password_reset_required = "false"
  password_length         = "20"
}

resource "aws_iam_policy" "iam_self_management" {
  name        = "iam-self-management"
  description = "Allow users to manage their own IAM credentials"
  policy      = "${data.aws_iam_policy_document.iam_self_management.json}"
}
