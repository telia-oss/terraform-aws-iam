# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "prefix" {
  description = "A prefix used for naming resources."
}

variable "trusted_account" {
  description = "ID of the account which is trusted with access to assume this role."
}

variable "mfa_window" {
  description = "A window in time (hours) after MFA authenticating where the user is allowed to assume the role."
  default     = "1"
}

variable "users" {
  type        = "list"
  description = "List of users in the trusted account which will be allowed to assume this role."
}

variable "role_description" {
  description = "A description to add to the role"
  default     = ""
}
