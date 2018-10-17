# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "admin_role_name" {
  value = "${aws_iam_role.admin.name}"
}

output "admin_role_arn" {
  value = "${aws_iam_role.admin.arn}"
}

output "admin_role_url" {
  value = "https://signin.aws.amazon.com/switchrole?account=${data.aws_iam_account_alias.current.account_alias}&roleName=${aws_iam_role.admin.name}&displayName=${aws_iam_role.admin.name}%20@%20${data.aws_iam_account_alias.current.account_alias}"
}

output "view_only_role_name" {
  value = "${aws_iam_role.view_only.name}"
}

output "view_only_role_arn" {
  value = "${aws_iam_role.view_only.arn}"
}

output "view_only_role_url" {
  value = "https://signin.aws.amazon.com/switchrole?account=${data.aws_iam_account_alias.current.account_alias}&roleName=${aws_iam_role.view_only.name}&displayName=${aws_iam_role.view_only.name}%20@%20${data.aws_iam_account_alias.current.account_alias}"
}
