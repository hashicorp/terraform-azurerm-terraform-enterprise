resource "random_string" "install_id" {
  length  = 8
  special = false
  upper   = false
}

locals {
  assistant_port             = 23010
  rendered_secondary_vm_size = "${coalesce(var.secondary_vm_size, var.primary_vm_size)}"
}
