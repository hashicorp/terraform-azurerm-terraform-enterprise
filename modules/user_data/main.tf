locals {
  replicated_base_config = {
    BypassPreflightChecks        = true
    DaemonAuthenticationPassword = random_string.password.result
    DaemonAuthenticationType     = "password"
    ImportSettingsFrom           = "/etc/ptfe-settings.json"
    LicenseFileLocation          = "/etc/${var.user_data_tfe_license_name}"
    TlsBootstrapHostname         = var.fqdn
    TlsBootstrapCert             = "/etc/tfe/tls.pem"
    TlsBootstrapKey              = "/etc/tfe/tls.key"
    TlsBootstrapType             = "server-path"
  }

  replicated_airgap_settings = var.installation_mode == "airgap" ? {
    LicenseBootstrapAirgapPackagePath = "/tmp/tfe/latest.airgap"
  } : {}

  user_data_release_sequence = {
    ReleaseSequence = var.user_data_release_sequence
  }

  no_proxy = join(
    ",",
    concat(
      [
        "127.0.0.1",
        "169.254.169.254",
        ".azure.com",
        ".windows.net",
        ".microsoft.com",
      ],
      var.no_proxy
    )
  )

  # if the installation mode is airpap, default to installing docker and azure-cli
  # note: online install installs docker
  install_prereq_software = coalesce(var.install_prereq_software, var.installation_mode == "airgap")
}

locals {
  # Build TFE configuration in JSON format by merging partial config local variables
  release_sequence = var.user_data_release_sequence != "" ? local.user_data_release_sequence : {}

  redis_configuration      = var.active_active ? local.redis_configs : {}
  tfe_configuration        = jsonencode(merge(local.base_configs, local.base_external_configs, local.external_azure_configs, local.redis_configuration))
  replicated_configuration = jsonencode(merge(local.replicated_base_config, local.release_sequence, local.replicated_airgap_settings))
}

locals {
  # Build TFE user data / custom data / cloud init
  tfe_user_data = templatefile(
    "${path.module}/templates/tfe.sh.tpl",
    {
      is_airgapped            = var.installation_mode == "airgap"
      install_prereq_software = local.install_prereq_software

      function-create-tfe-config    = data.template_file.create-tfe-config.rendered
      function-proxy-config         = data.template_file.proxy-config.rendered
      function-install-software     = data.template_file.install-software.rendered
      function-install-os-packages  = data.template_file.install-os-packages.rendered
      function-retrieve-tfe-license = data.template_file.retrieve-tfe-license.rendered
      function-install-tfe          = data.template_file.install-tfe.rendered
      function-wait-tfe-ready       = data.template_file.wait-tfe-ready.rendered
      function-download-airgap      = data.template_file.download-airgap.rendered
    }
  )
}

resource "random_string" "password" {
  length  = 16
  special = false
}

resource "random_id" "archivist_token" {
  byte_length = 16
}

resource "random_id" "cookie_hash" {
  byte_length = 16
}

resource "random_id" "enc_password" {
  byte_length = 16
}

resource "random_id" "install_id" {
  byte_length = 16
}

resource "random_id" "internal_api_token" {
  byte_length = 16
}

resource "random_id" "root_secret" {
  byte_length = 16
}

resource "random_id" "registry_session_secret_key" {
  byte_length = 16
}

resource "random_id" "registry_session_encryption_key" {
  byte_length = 16
}

resource "random_id" "user_token" {
  byte_length = 16
}

locals {
  base_configs = {
    hostname = {
      value = var.fqdn
    }

    installation_type = {
      value = "production"
    }

    production_type = {
      value = "external"
    }

    archivist_token = {
      value = random_id.archivist_token.hex
    }

    ca_certs = {
      value = var.user_data_ca
    }

    cookie_hash = {
      value = random_id.cookie_hash.hex
    }

    enc_password = {
      value = random_id.enc_password.hex
    }

    extra_no_proxy = {
      value = ""
    }

    install_id = {
      value = random_id.install_id.hex
    }

    internal_api_token = {
      value = random_id.internal_api_token.hex
    }

    registry_session_encryption_key = {
      value = random_id.registry_session_encryption_key.hex
    }

    registry_session_secret_key = {
      value = random_id.registry_session_secret_key.hex
    }

    root_secret = {
      value = random_id.root_secret.hex
    }

    user_token = {
      value = random_id.user_token.hex
    }

    tls_vers = {
      value = var.user_data_tfe_tls_vers
    }

    hairpin_addressing = {
      value = var.active_active && var.user_data_tfe_hairpin_addressing ? "1" : "0"
    }

    capacity_memory = {
      value = var.user_data_tfe_capacity_memory
    }

    tbw_image = {
      value = var.user_data_tfe_tbw_image
    }
  }

  base_external_configs = {
    enable_active_active = {
      value = var.active_active ? "1" : "0"
    }

    pg_dbname = {
      value = var.user_data_pg_dbname
    }

    pg_netloc = {
      value = var.user_data_pg_netloc
    }

    pg_password = {
      value = var.user_data_pg_password
    }

    pg_user = {
      value = var.user_data_pg_user
    }

    pg_extra_params = {
      value = var.user_data_pg_extra_params
    }
  }

  redis_configs = {
    redis_host = {
      value = var.user_data_redis_host
    }

    redis_pass = {
      value = var.user_data_redis_pass
    }

    redis_port = {
      value = var.user_data_redis_port
    }

    redis_use_password_auth = {
      value = var.redis_enable_authentication == true ? "1" : "0"
    }

    redis_use_tls = {
      value = var.user_data_redis_use_tls == true ? "1" : "0"
    }
  }

  external_azure_configs = {
    azure_account_name = {
      value = var.user_data_azure_account_name
    }

    azure_account_key = {
      value = var.user_data_azure_account_key
    }

    azure_container = {
      value = var.user_data_azure_container_name
    }

    placement = {
      value = "placement_azure"
    }
  }
}

data "template_file" "create-tfe-config" {
  template = file("${path.module}/templates/create-tfe-config.func")

  vars = {
    replicated = base64encode(local.replicated_configuration)
    settings   = base64encode(local.tfe_configuration)

    user_data_cert = base64encode(var.user_data_cert)
    user_data_key  = base64encode(var.user_data_cert_key)
  }
}

data "template_file" "proxy-config" {
  template = file("${path.module}/templates/proxy-config.func")

  vars = {
    distribution = var.distribution

    proxy_ip   = var.proxy_ip
    proxy_port = var.proxy_port
    proxy_cert = var.proxy_cert_name
    no_proxy   = local.no_proxy

    bootstrap_storage_account_name           = var.user_data_bootstrap_storage_account_name
    bootstrap_storage_account_container_name = var.user_data_bootstrap_storage_container_name
  }
}

data "template_file" "install-os-packages" {
  template = file("${path.module}/templates/install-os-packages.func")

  vars = {
    distribution = var.distribution
  }
}

data "template_file" "retrieve-tfe-license" {
  template = file("${path.module}/templates/retrieve-tfe-license.func")

  vars = {
    bootstrap_storage_account_container_name = var.user_data_bootstrap_storage_container_name
    bootstrap_storage_account_name           = var.user_data_bootstrap_storage_account_name
    tfe_license_name                         = var.user_data_tfe_license_name
  }
}

data "template_file" "install-tfe" {
  template = file("${path.module}/templates/install-tfe.func")

  vars = {
    distribution  = var.distribution
    active_active = var.active_active
    is_airgapped  = var.installation_mode == "airgap"

    proxy_ip   = var.proxy_ip
    proxy_port = var.proxy_port
    no_proxy   = local.no_proxy
  }
}

data "template_file" "wait-tfe-ready" {
  template = file("${path.module}/templates/wait-tfe-ready.func")

  vars = {
    fqdn = var.fqdn
  }
}

data "template_file" "download-airgap" {
  template = file("${path.module}/templates/download-airgap.func")

  vars = {
    is_airgapped                             = var.installation_mode == "airgap"
    bootstrap_storage_account_container_name = var.user_data_bootstrap_storage_container_name
    bootstrap_storage_account_name           = var.user_data_bootstrap_storage_account_name

    replicated_blob_name = var.user_data_bootstrap_replicated_blob_name
    tfe_blob_name        = var.user_data_bootstrap_tfe_blob_name
  }
}

data "template_file" "install-software" {
  template = file("${path.module}/templates/install-software.func")

  vars = {
    distribution            = var.distribution
    install_prereq_software = local.install_prereq_software
  }
}