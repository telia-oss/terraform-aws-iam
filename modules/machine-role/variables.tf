# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name" {
  description = "The role's name."
}

variable "trusted_principals" {
  description = "ARN of the principals which will be allowed to assume this role."
  default     = []
}
