#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup miscellanea stuff"' ERR

#echo "::group::Setup podman testing"
#dnf5 -y --repo=updates-testing swap podman podman
#echo "::endgroup::"

{
	[[ ! -f /.dockerenv ]] && {
		touch /.dockerenv
		trap 'rm /.dockerenv' EXIT
	}
	mkdir -p /var/home /var/roothome
	export NONINTERACTIVE=1
	bash < <(curl -fsSL https://raw.githubusercontent.com/Zeglius/packages/refs/heads/brew-script/containerfile_scripts/brew.sh)
} || echo "::warning::Failed to install: brew"

{
	dnf5 install -y --setopt=install_weak_deps=0 podman-machine ||
		echo "::warning::Failed to install: podman-machine"
}

{
	dnf5 install -y "$(curl -s https://api.github.com/repos/Abdenasser/neohtop/releases/latest | jq -r '.assets[].browser_download_url' | grep 'x86_64.rpm')" ||
		echo "::warning::Failed to install neohtop"
}
