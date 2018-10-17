# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "name" {
  value = "${aws_iam_role.main.name}"
}

output "arn" {
  value = "${aws_iam_role.main.arn}"
}

output "url" {
  value = "https://signin.aws.amazon.com/switchrole?account=${data.aws_iam_account_alias.current.account_alias}&roleName=${aws_iam_role.main.name}&displayName=${var.prefix}%20@%20${data.aws_iam_account_alias.current.account_alias}"
}
