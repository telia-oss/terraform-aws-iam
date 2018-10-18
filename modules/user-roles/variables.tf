# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
  default     = ""
}

variable "trusted_account" {
  description = "ID of the account which is trusted with access to assume this role."
}

variable "admin_users" {
  description = "List of users in the trusted account which will be allowed to assume the admin role."
  default     = []
}

variable "admin_mfa_window" {
  description = "A window in time (hours) after MFA authenticating where users are allowed to assume the admin role."
  default     = "1"
}

variable "view_only_users" {
  description = "List of users in the trusted account which will be allowed to assume the view-only role."
  default     = []
}

variable "view_only_mfa_window" {
  description = "A window in time (hours) after MFA authenticating where users are allowed to assume the view-only role."
  default     = "8"
}
