# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "username" {
  description = "Desired name for the IAM user."
}

variable "keybase" {
  description = "Keybase username. Used to encrypt password and access key."
}

variable "ssh_key" {
  description = "Public SSH key for the user. Exported for use in other modules."
  default     = ""
}
