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
{
	dnf5 -yq install \
		plasma-workspace-devel \
		kvantum \
		qt6-qtmultimedia-devel \
		qt6-qt5compat-devel \
		libplasma-devel \
		qt6-qtbase-devel \
		qt6-qtwayland-devel \
		plasma-activities-devel \
		kf6-kpackage-devel \
		kf6-kglobalaccel-devel \
		qt6-qtsvg-devel \
		wayland-devel \
		plasma-wayland-protocols \
		kf6-ksvg-devel \
		kf6-kcrash-devel \
		kf6-kguiaddons-devel \
		kf6-kcmutils-devel \
		kf6-kio-devel \
		kdecoration-devel \
		kf6-ki18n-devel \
		kf6-knotifications-devel \
		kf6-kirigami-devel \
		kf6-kiconthemes-devel \
		cmake \
		gmp-ecm-devel \
		kf5-plasma-devel \
		libepoxy-devel \
		kwin-devel \
		kf6-karchive \
		kf6-karchive-devel \
		plasma-wayland-protocols-devel \
		qt6-qtbase-private-devel \
		qt6-qtbase-devel

	pushd "${tmpdir:=$(mktemp -p)}"

	git clone https://gitgud.io/wackyideas/aerothemeplasma.git .
	sh compile.sh || :
	chmod +x install_plasmoids.sh && ./install_plasmoids.sh
	chmod +x install_plasma_components.sh && ./install_plasma_components.sh

	popd && rm -rf "$tmpdir" && unset -v tmpdir
}

# Install drop-in packages
{
	for pkg in /tmp/packages/*.rpm; do
		[[ ! -e $pkg ]] && break
		dnf5 install -y "$pkg" || echo "::warning::Couldn't install package '$pkg'"
	done
}
