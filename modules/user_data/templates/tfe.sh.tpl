#!/usr/bin/env bash

set -e -u -o pipefail

${function-install-os-packages}
${function-install-software}
${function-download-airgap}
${function-create-tfe-config}
${function-proxy-config}
${function-retrieve-tfe-license}
${function-install-tfe}
${function-wait-tfe-ready}

install_os_packages

%{ if install_prereq_software ~}
install_software
%{ endif ~}
%{ if is_airgapped ~}
download_airgap
%{ endif ~}

create_tfe_config
proxy_config
retrieve_tfe_license

install_tfe
wait_tfe_ready
