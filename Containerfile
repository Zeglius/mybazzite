ARG BASE_IMAGE=${BASE_IMAGE:-ghcr.io/ublue-os/bazzite-nvidia:testing}
FROM ${BASE_IMAGE} as mybazzite

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

COPY ./build_scripts/ /tmp/build_scripts/

RUN --mount=type=cache,dst=/var/cache \
    mkdir -p /var/lib/alternatives \
    && dnf5 -y update uupd \
    && /tmp/build_scripts/init

COPY ./system_files/ /

# Cosmic env
FROM mybazzite as mybazzite-cosmic

RUN --mount=type=cache,dst=/var/cache \
    dnf5 -y install @cosmic-desktop && \
    ostree container commit

# Hyprland env
FROM mybazzite as mybazzite-hyprland
RUN --mount=type=cache,dst=/var/cache \
    dnf5 -y copr enable solopasha/hyprland && \
    dnf5 -y copr enable errornointernet/quickshell && \
    dnf5 -y install hyprland quickshell && \
    dnf5 -y copr disable solopasha/hyprland && \
    dnf5 -y copr disable errornointernet/quickshell && \
    ostree container commit

# Default to base image
FROM mybazzite
