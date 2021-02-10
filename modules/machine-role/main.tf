# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
data "aws_iam_account_alias" "current" {}

resource "aws_iam_role" "main" {
  name                  = var.name
  description           = "Machine user role"
  assume_role_policy    = data.aws_iam_policy_document.assume.json
  force_detach_policies = "true"
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = var.policy_arn
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = var.trusted_principals

    }
  }
}
