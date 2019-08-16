data "template_file" "ssh_config" {
  template = "${file("${path.module}/templates/ssh_config")}"

  vars = {
    hostname     = "${element(azurerm_public_ip.primary.*.ip_address, 0)}"
    ssh_user     = "${var.username}"
    keyfile_path = "${var.ssh["private_key_path"]}"
  }
}

resource "local_file" "ssh_config" {
  filename = "${local.ssh_config_path}"
  content  = "${data.template_file.ssh_config.rendered}"
}
