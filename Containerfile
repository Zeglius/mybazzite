FROM ghcr.io/ublue-os/bazzite-nvidia:testing

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
#
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=bind,src=./build_scripts,dst=/tmp/build_scripts,relabel=shared \
    mkdir -p /var/lib/alternatives && \
    (shopt -s nullglob; for f in /tmp/build_scripts/*.sh; do bash "$f"; done) && \
    bootc container lint
