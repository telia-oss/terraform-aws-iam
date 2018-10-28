# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_iam_account_alias" "current" {}

locals {
  name_prefix         = "${var.name_prefix == "" ? "" : "${var.name_prefix}-"}"
  admin_role_name     = "${local.name_prefix}admin"
  view_only_role_name = "${local.name_prefix}view-only"
  iam_boundary_name   = "${local.name_prefix}iam-permissions-boundary"
  view_only_users     = "${concat(var.admin_users, var.view_only_users)}"
}

resource "aws_iam_role" "admin" {
  name                  = "${local.admin_role_name}"
  description           = "Admin role assumable from a trusted account"
  assume_role_policy    = "${data.aws_iam_policy_document.admin_assume.json}"
  permissions_boundary  = "${aws_iam_policy.boundary.arn}"
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
  name                  = "${local.view_only_role_name}"
  description           = "View-only role assumable from a trusted account"
  assume_role_policy    = "${data.aws_iam_policy_document.view_only_assume.json}"
  permissions_boundary  = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
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
