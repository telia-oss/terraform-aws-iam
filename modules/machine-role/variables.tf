# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name" {
  description = "The role's name."
}

variable "principal_arns" {
  description = "ARN of the principals which will be allowed to assume this role."
}
