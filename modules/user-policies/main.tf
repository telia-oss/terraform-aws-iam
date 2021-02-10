data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.name_prefix == "" ? "" : "${var.name_prefix}-"}"
}

resource "aws_iam_policy" "iam_self_management" {
  name        = "${local.name_prefix}iam-self-management"
  description = "Allow users to manage their own IAM credentials"
  policy      = data.aws_iam_policy_document.iam_self_management.json
}
