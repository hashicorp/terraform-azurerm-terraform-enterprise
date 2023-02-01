# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Create files for SSH config.
resource "local_file" "private_key_pem" {
  filename = "${path.module}/work/private-key.pem"

  content         = module.standalone_external.instance_private_key
  file_permission = "0600"
}

resource "local_file" "ssh_config" {
  filename = "${path.module}/work/ssh-config"

  content = <<__eof
Host default
    Hostname ${module.standalone_external.fqdn}
    User ${module.standalone_external.instance_user_name}
    Port 22
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile ${local_file.private_key_pem.filename}
    IdentitiesOnly yes
    LogLevel FATAL
__eof

}