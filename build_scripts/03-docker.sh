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
	if (( $(lsb_release -sr) == 42 )); then
		echo "::info::Missing docker packages in f42, falling back to testing repos..."
		dnf5 install -y --enablerepo=docker-ce-testing "${pkgs[@]}"
	fi
}

dnf5 config-manager setopt docker-ce-stable.enabled=0
