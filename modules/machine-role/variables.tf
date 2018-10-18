# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name" {
  description = "The name of the role."
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply to the role."
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "trusted_principals" {
  description = "ARN of the principals which will be allowed to assume this role."
  default     = []
}
