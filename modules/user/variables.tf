# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "name" {
  description = "The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces."
}

variable "path" {
  description = "Path in which to create the user."
  default     = "/"
}

variable "keybase" {
  description = "Keybase username in the form keybase:username."
}
