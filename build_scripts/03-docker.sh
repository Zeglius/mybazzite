#!/usr/bin/env -S bash -euo pipefail

pkgs=(
	docker-ce
	docker-ce-cli
	containerd.io
	docker-buildx-plugin
	docker-compose-plugin
)

dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
dnf5 install -y --setopt=install_weak_deps=0 "${pkgs[@]}" || {
	# Use test packages if docker pkgs is not available for f42
	if (($(lsb_release -sr) == 42)); then
		echo "::info::Missing docker packages in f42, falling back to test repos..."
		dnf5 install -y --enablerepo=docker-ce-test "${pkgs[@]}"
	fi
}

# Load iptable_nat module for docker-in-docker.
# See:
#   - https://github.com/ublue-os/bluefin/issues/2365
#   - https://github.com/devcontainers/features/issues/1235
mkdir -p /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

dnf5 config-manager setopt docker-ce-stable.enabled=0
