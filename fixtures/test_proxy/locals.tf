# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  mitmproxy_selected = var.mitmproxy_ca_certificate_secret != null && var.mitmproxy_ca_private_key_secret != null
}