data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "boundary" {
  name        = "${local.iam_boundary_name}"
  description = "Permission boundary for IAM users and roles"
  policy      = "${data.aws_iam_policy_document.boundary.json}"
}

data "aws_iam_policy_document" "boundary" {
  # Allow full admin by default and use deny to restrict
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }

  # Protect the boundary from being tempered with by users
  statement {
    effect = "Deny"

    actions = [
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.iam_boundary_name}",
    ]
  }

  # Prevent users from locking out other admin users, the machine user or the organisations master account.
  statement {
    effect = "Deny"

    # TODO: Figure out the proper scope (or switch to not_actions to allow list/describe etc)
    actions = [
      "iam:*",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*OrganizationAccountAccessRole",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/machine-user*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.admin_role_name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.view_only_role_name}",
    ]
  }

  # Require that the boundary is included when creating/updating IAM users and roles to prevent escalating privileges
  # This list should include any action which supports the iam:PermissionsBoundary condition key:
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/list_identityandaccessmanagement.html#identityandaccessmanagement-iam_PermissionsBoundary
  statement {
    effect = "Deny"

    actions = [
      "iam:CreateRole",
      "iam:PutRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:CreateUser",
      "iam:PutUserPolicy",
      "iam:AttachUserPolicy",
      "iam:DetachUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:PutUserPermissionsBoundary",
    ]

    resources = ["*"]

    condition = {
      test     = "StringNotEquals"
      variable = "iam:PermissionsBoundary"

      values = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.iam_boundary_name}",
      ]
    }
  }

  statement {
    effect = "Deny"

    actions = [
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteUserPermissionsBoundary",
    ]

    resources = ["*"]
  }
}
