# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "name" {
  description = "The user's name."
  value       = aws_iam_user.main.name
}

output "keybase" {
  description = "Keybase username used to encrypt the user's initial password."
  value       = var.keybase
}

output "instructions" {
  description = "User instructions for doing the initial setup of MFA and securing AWS credentials."

  value = <<EOF

1. Decrypt your password using your keybase.io account (PGP key: keybase:${var.keybase}):

  echo ${aws_iam_user_login_profile.main.encrypted_password} | base64 --decode | keybase pgp decrypt

1a. If you are windows user, you can decrypt your password on the keybase website (https://keybase.io/decrypt) by pasting the following:

  -----BEGIN PGP MESSAGE-----
  Version: Keybase OpenPGP v2.0.76
  Comment: https://keybase.io/crypto

  ${aws_iam_user_login_profile.main.encrypted_password}
  -----END PGP MESSAGE-----

2. Log into the console:

  URL:      https://${data.aws_iam_account_alias.current.account_alias}.signin.aws.amazon.com/console
  Username: ${aws_iam_user.main.name}
  Password: <your-decrypted-password from step 1>

3. Enable virtual MFA using AWS console and [Authy](https://authy.com/):

  https://console.aws.amazon.com/iam/home?region=global#/users/${aws_iam_user.main.name}?section=security_credentials

  IMPORTANT: After enabling MFA, log out of the console and in again with MFA.

4. Create a new IAM access key in the AWS console.

5. Install [vaulted](https://github.com/miquella/vaulted) and add a profile to vaulted:

  $ vaulted add ${data.aws_iam_account_alias.current.account_alias}-user
  Follow the instructions and add your keys and MFA device:
  Access Key ID: <your-access-key from step 4>
  Secret Access Key: <your-secret-access-key from step 4>
  MFA: arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${aws_iam_user.main.name}

EOF
}
