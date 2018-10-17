# ------------------------------------------------------------------------------
# Output
# ------------------------------------------------------------------------------
output "name" {
  value = "${module.role.name}"
}

output "arn" {
  value = "${module.role.arn}"
}

output "url" {
  value = "${module.role.url}"
}
