# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
  default     = ""
}

variable "admin_role_suffix" {
  description = "The suffix appended to the name_prefix for the name of the admin role"
  default     = "admin"
}

variable "view_only_role_suffix" {
  description = "The suffix appended to the name_prefix for the name of the view-only role"
  default     = "view-only"
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
