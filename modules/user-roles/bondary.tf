data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "boundary" {
  name        = "iam-permissions-boundary"
  description = "Permission boundary for IAM users and roles"
  policy      = "${data.aws_iam_policy_document.boundary.json}"
}

data "aws_iam_policy_document" "boundary" {
  # Require that the boundary is attached
  statement {
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:CreateUser",
      "iam:AttachUserPolicy",
      "iam:DetachUserPolicy",
      "iam:DeleteUserPolicy",
      "iam:PutUserPermissionsBoundary",
    ]

    condition = {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/iam-permissions-boundary"]
    }
  }

  # Disallow tempering with the boundary
  statement {
    effect = "Deny"

    actions = [
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/iam-permissions-boundary",
    ]
  }

  # Protect the organisation access and machine user roles
  statement {
    effect = "Deny"

    actions = [
      "iam:*",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/OrganizationAccountAccessRole",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/machine-user-*",
    ]
  }
}
