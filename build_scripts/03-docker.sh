#!/usr/bin/env -S bash -euo pipefail
dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo &&
	dnf5 install -y --setopt=install_weak_deps=0 \
		docker-ce \
		docker-ce-cli \
		containerd.io \
		docker-buildx-plugin \
		docker-compose-plugin

dnf5 config-manager setopt docker-ce-stable.enabled=0
