#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup miscellanea stuff"' ERR

#echo "::group::Setup podman testing"
#dnf5 -y --repo=updates-testing swap podman podman
#echo "::endgroup::"

#{
#	[[ ! -f /.dockerenv ]] && {
#		touch /.dockerenv
#		trap 'rm /.dockerenv' EXIT
#	}
#	mkdir -p /var/home /var/roothome
#	export NONINTERACTIVE=1
#	bash < <(curl -fsSL https://raw.githubusercontent.com/Zeglius/packages/refs/heads/brew-script/containerfile_scripts/brew.sh)
#} || echo "::warning::Failed to install: brew"

{
	dnf5 install -y --setopt=install_weak_deps=0 podman-machine ||
		echo "::warning::Failed to install: podman-machine"
}

{
	dnf5 install -y "$(curl -s https://api.github.com/repos/Abdenasser/neohtop/releases/latest | jq -r '.assets[].browser_download_url' | grep 'x86_64.rpm')" ||
		echo "::warning::Failed to install neohtop"
}

# Lock layering
{
	sed -i -e 's|^#LockLayering=false|LockLayering=true|' /etc/rpm-ostreed.conf
}

# Restore dnf symlink
{
	rm /usr/bin/dnf
	(cd /usr/bin && ln -s dnf5 dnf)
}

# Install katsu
{
	dnf5 install -y katsu
}

# Install rclone
{
	dnf5 install -y rclone
	ln -s /usr/bin/rclone /sbin/mount.rclone || :
}

# Install windows aero theme
# See https://gitgud.io/wackyideas/aerothemeplasma
# {

# 	git clone https://github.com/winblues/blutiger.git "${tmpdir:=$(mktemp -d)}" &&
# 		pushd "$tmpdir/files/scripts"
# 	chmod +x ./10-aero-theme.sh && ./10-aero-theme.sh
# 	popd && rm -rf "$tmpdir" && unset -v tmpdir
# }

# Install drop-in packages
{
	for pkg in /tmp/packages/*.rpm; do
		[[ ! -e $pkg ]] && break
		dnf5 install -y "$pkg" || echo "::warning::Couldn't install package '$pkg'"
	done
}

# Install kiwi-ng
{
	dnf5 install -y kiwi-cli python3-kiwi-stackbuild-plugin
} || echo "::warning::Couldn't install kiwi tooling"
