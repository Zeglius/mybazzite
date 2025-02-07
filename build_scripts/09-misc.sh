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
	curl -fsSLo /tmp/brew-install https://raw.githubusercontent.com/Zeglius/packages/refs/heads/brew-script/containerfile_scripts/brew.sh &&
		chmod +x /tmp/brew-install &&
		/tmp/brew-install
} || echo "::warning::Failed to install: brew"
