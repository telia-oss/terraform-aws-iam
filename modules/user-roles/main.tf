# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_iam_account_alias" "current" {}

locals {
  name_prefix     = "${var.name_prefix == "" ? "" : "${var.name_prefix}-"}"
  view_only_users = "${concat(var.admin_users, var.view_only_users)}"
}

resource "aws_iam_role" "admin" {
  name                  = "${local.name_prefix}${var.admin_role_suffix}"
  description           = "Admin role assumable from a trusted account"
  assume_role_policy    = "${data.aws_iam_policy_document.admin_assume.json}"
  force_detach_policies = "true"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = "${aws_iam_role.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "admin_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = [
        "${formatlist("arn:aws:iam::%s:user/%s", var.trusted_account, var.admin_users)}",
      ]
    }

    condition = {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition = {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["${var.admin_mfa_window * 3600}"]
    }
  }
}

resource "aws_iam_role" "view_only" {
  name                  = "${local.name_prefix}${var.view_only_role_suffix}"
  description           = "View-only role assumable from a trusted account"
  assume_role_policy    = "${data.aws_iam_policy_document.view_only_assume.json}"
  force_detach_policies = "true"
}

resource "aws_iam_role_policy_attachment" "view_only" {
  role       = "${aws_iam_role.view_only.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

data "aws_iam_policy_document" "view_only_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = [
        "${formatlist("arn:aws:iam::%s:user/%s", var.trusted_account, local.view_only_users)}",
      ]
    }

    condition = {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition = {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = ["${var.view_only_mfa_window * 3600}"]
    }
  }
}
