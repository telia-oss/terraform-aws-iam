# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "instructions" {
  value = <<EOF
1. Decrypt your password using Keybase.io:
echo ${aws_iam_user_login_profile.main.encrypted_password} | base64 --decode | keybase pgp decrypt
2. Log into the console:
  URL:      https://${data.aws_iam_account_alias.current.account_alias}.signin.aws.amazon.com/console
  Username: ${var.username}
  Password: <your-decrypted-password>
3. Enable (virtual) MFA using the console:
  https://console.aws.amazon.com/iam/home?region=global#/users/${var.username}?section=security_credentials
4. Decrypt your secret access key:
echo ${aws_iam_access_key.main.encrypted_secret} | base64 --decode | keybase pgp decrypt
5. Install (requires homebrew) and add a profile to vaulted:
  $ brew install vaulted
  $ vaulted add <profile-name>
  Follow the instructions and add your keys and MFA device:
  Access Key ID: ${aws_iam_access_key.main.id}
  Secret Access Key: <your-decrypted-secret-access-key>
  MFA: arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${var.username}
EOF
}

output "name" {
  value = "${var.username}"
}

output "password" {
  value = "${aws_iam_user_login_profile.main.encrypted_password}"
}

output "ssh_key" {
  value = "${var.ssh_key}"
}

output "keybase" {
  value = "${var.keybase}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.main.id}"
}

output "secret_access_key" {
  value = "${aws_iam_access_key.main.encrypted_secret}"
}
