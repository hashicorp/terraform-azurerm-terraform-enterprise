locals {
  rhel_release = var.vm_image_id == "rhel8" ?  "8_6" : "7.8"
}