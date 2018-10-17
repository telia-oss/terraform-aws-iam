# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

resource "aws_iam_user" "main" {
  name          = "${var.username}"
  force_destroy = "true"
}

resource "aws_iam_user_login_profile" "main" {
  user                    = "${aws_iam_user.main.name}"
  pgp_key                 = "keybase:${var.keybase}"
  password_reset_required = "false"
}

resource "aws_iam_access_key" "main" {
  user    = "${aws_iam_user.main.name}"
  pgp_key = "keybase:${var.keybase}"
}

resource "aws_iam_user_policy_attachment" "view_only_policy" {
  user       = "${aws_iam_user.main.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_user_policy" "inspect" {
  name   = "inspect-own-user"
  user   = "${aws_iam_user.main.name}"
  policy = "${data.aws_iam_policy_document.inspect.json}"
}

resource "aws_iam_user_policy" "manage" {
  name   = "manage-own-user"
  user   = "${aws_iam_user.main.name}"
  policy = "${data.aws_iam_policy_document.manage.json}"
}

resource "aws_iam_user_policy" "assume" {
  name   = "assume-cross-account-roles"
  user   = "${aws_iam_user.main.name}"
  policy = "${data.aws_iam_policy_document.assume.json}"
}
