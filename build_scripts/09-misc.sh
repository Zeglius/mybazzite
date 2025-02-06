#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup miscellanea stuff"' ERR

#echo "::group::Setup podman testing"
#dnf5 -y --repo=updates-testing swap podman podman
#echo "::endgroup::"

(
	export NONINTERACTIVE=1
	bash <(curl -sSL https://raw.githubusercontent.com/Zeglius/packages/refs/heads/brew-script/containerfile_scripts/brew.sh)
)
