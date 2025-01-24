dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf5 install -y --setopt=install_weak_deps=0 \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin
