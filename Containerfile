FROM ghcr.io/ublue-os/bazzite-nvidia:testing as mybazzite

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

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    mkdir -p /var/lib/alternatives && \
    /tmp/build_scripts/init && \
    ostree container commit

# Cosmic env
FROM mybazzite as mybazzite-cosmic

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    dnf5 -y copr enable ryanabx/cosmic-epoch && \
    dnf5 -y install cosmic-desktop && \
    dnf5 -y copr disable ryanabx/cosmic-epoch && \
    : "Enable services" && \
    systemctl disable gddm || : && \
    systemctl disable sddm || : && \
    systemctl enable cosmic-greeter && \
    ostree container commit


# Default to base image
FROM mybazzite