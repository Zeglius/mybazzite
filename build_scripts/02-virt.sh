#!/usr/bin/env -S bash -euo pipefail

dnf5 install -y --setopt=install_weak_deps=0 \
    cockpit \
    cockpit-machines \
    crun-vm \
    edk2-ovmf \
    libvirt \
    qemu \
    virt-install \
    virt-viewer &&
    systemctl enable libvirtd
