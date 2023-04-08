locals {
  tfe_ssh_config = [for addr in toset(var.tfe_instance_ip_addresses) : templatefile("${path.module}/templates/ssh-config.tpl", {
    instance_ip_address = addr
    instance_user_name  = var.tfe_instance_user_name
    private_key_path    = var.tfe_private_key_path
  })]

  setup_ssh = templatefile("${path.module}/templates/setup-ssh.sh.tpl", {
    ssh_config       = local.tfe_ssh_config
    private_key_data = var.tfe_private_key_data_base64
    private_key_path = var.tfe_private_key_path
    ssh_config_path  = var.tfe_ssh_config_path
  })
}