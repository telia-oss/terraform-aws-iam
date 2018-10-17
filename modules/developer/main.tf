# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
module "role" {
  source = "../role"

  prefix          = "${var.prefix}-developer"
  trusted_account = "${var.trusted_account}"
  mfa_window      = "${var.mfa_window}"
  users           = "${var.users}"
}

resource "aws_iam_role_policy" "protect_role" {
  name   = "protect-role-policy"
  role   = "${module.role.name}"
  policy = "${data.aws_iam_policy_document.protect_role.json}"
}

data "aws_iam_policy_document" "protect_role" {
  # NOTE: Disallow users from making changes to the developer role and policies.
  statement {
    effect = "Deny"

    not_actions = [
      "iam:GenerateServiceLastAccessedDetails",
      "iam:ListInstanceProfilesForRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:GetRolePolicy",
    ]

    resources = [
      "${module.role.arn}",
    ]
  }
}

resource "aws_iam_role_policy" "inspect_role" {
  name   = "inspect-role-policy"
  role   = "${module.role.name}"
  policy = "${data.aws_iam_policy_document.inspect_role.json}"
}

data "aws_iam_policy_document" "inspect_role" {
  # NOTE: We allow reading the policies so users can better understand the roles scope.
  statement {
    effect = "Allow"

    actions = [
      "iam:GetRolePolicy",
    ]

    resources = [
      "${module.role.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:GetPolicyVersion",
    ]

    resources = [
      "*",
    ]
  }
}
