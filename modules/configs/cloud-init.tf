locals {
  encryption_password = "${coalesce(var.encryption_password, random_string.default_enc_password.result)}"
}

data "template_file" "replicated_config" {
  template = "${file("${path.module}/templates/replicated/replicated.conf")}"

  vars = {
    installation_mode = "${local.install_mode}"
    airgap            = "${local.is_airgap}"
    proxy_url         = "${var.http_proxy_url}"
    console_password  = "${random_pet.console_password.id}"
    app_endpoint      = "${var.cluster_endpoint}"
    release_sequence  = "${var.release_sequence}"
  }
}

data "template_file" "replicated_ptfe_config" {
  template = "${file("${path.module}/templates/replicated/replicated-ptfe.conf")}"

  vars = {
    airgap                 = "${local.is_airgap}"
    installation_mode      = "${local.install_mode}"
    app_endpoint           = "${var.cluster_endpoint}"
    enc_password           = "${local.encryption_password}"
    iact_subnet_list       = "${var.iact["subnet_list"]}"
    iact_subnet_time_limit = "${var.iact["subnet_time_limit"]}"
    pg_user                = "${var.postgresql["user"]}"
    pg_password            = "${var.postgresql["password"]}"
    pg_netloc              = "${var.postgresql["address"]}"
    pg_dbname              = "${var.postgresql["database"]}"
    pg_extra_params        = "${var.postgresql["extra_params"]}"
    azure_account_name     = "${var.azure_es["account_name"]}"
    azure_account_key      = "${var.azure_es["account_key"]}"
    azure_container        = "${var.azure_es["container"]}"
  }
}

data "template_file" "proxy_sh" {
  template = "${file("${path.module}/templates/cloud-init/proxy.sh")}"

  vars = {
    proxy_url = "${var.http_proxy_url}"
  }
}

data "template_file" "aaa_proxy_b64" {
  template = "${file("${path.module}/templates/cloud-init/00aaa_proxy")}"

  vars = {
    proxy_url = "${var.http_proxy_url}"
  }
}

data "template_file" "cloud_config" {
  count    = "${var.primary_count}"
  template = "${file("${path.module}/templates/cloud-init/cloud-config.yaml")}"

  vars = {
    airgap_package_url   = "${var.airgap["package_url"]}"
    airgap_installer_url = "${var.airgap["installer_url"]}"
    setup_token          = "${random_string.setup_token.result}"
    proxy_url            = "${var.http_proxy_url}"
    ptfe_url             = "${var.installer_url}"
    role_id              = "${count.index}"
    import_key           = "${var.import_key}"
    distro               = "${var.distribution}"
    aaa_proxy_b64        = "${base64encode(data.template_file.aaa_proxy_b64.rendered)}"
    proxy_b64            = "${base64encode(data.template_file.proxy_sh.rendered)}"
    bootstrap_token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    license_b64          = "${base64encode(file("${var.license_file}"))}"
    rptfeconf            = "${base64encode(data.template_file.replicated_ptfe_config.rendered)}"
    replconf             = "${base64encode(data.template_file.replicated_config.rendered)}"
    install_ptfe_sh      = "${base64encode(file("${path.module}/files/install-ptfe.sh"))}"
    role                 = "${ count.index == 0 ? "main" : "primary" }"
    cluster_api_endpoint = "${var.cluster_api_endpoint}:6443"
    assistant_host       = "http://${var.cluster_api_endpoint}:${var.assistant_port}"
    cert_thumbprint      = "${var.cert_thumbprint}"
    ca_bundle_url        = "${var.ca_bundle_url}"
    weave_cidr           = "${var.weave_cidr}"
    repl_cidr            = "${var.repl_cidr}"
  }
}

data "template_cloudinit_config" "config" {
  count         = "${var.primary_count}"
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_config.*.rendered[count.index]}"
  }
}

data "template_file" "cloud_config_secondary" {
  template = "${file("${path.module}/templates/cloud-init/cloud-config.yaml")}"

  vars = {
    proxy_url            = "${var.http_proxy_url}"
    ptfe_url             = "${var.installer_url}"
    import_key           = "${var.import_key}"
    bootstrap_token      = "${random_string.bootstrap_token_id.result}.${random_string.bootstrap_token_suffix.result}"
    cluster_api_endpoint = "${var.cluster_api_endpoint}:6443"
    assistant_host       = "http://${var.cluster_api_endpoint}:${var.assistant_port}"
    setup_token          = "${random_string.setup_token.result}"
    install_ptfe_sh      = "${base64encode(file("${path.module}/files/install-ptfe.sh"))}"
    role                 = "secondary"
    distro               = "${var.distribution}"
    aaa_proxy_b64        = "${base64encode(data.template_file.aaa_proxy_b64.rendered)}"
    proxy_b64            = "${base64encode(data.template_file.proxy_sh.rendered)}"
    ca_bundle_url        = "${var.ca_bundle_url}"
  }
}

data "template_cloudinit_config" "config_secondary" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_config_secondary.rendered}"
  }
}
