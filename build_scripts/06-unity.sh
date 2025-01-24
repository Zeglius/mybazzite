#!/usr/bin/env -S bash -euo pipefail
mkdir -p /opt || true
sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo'
dnf5 install -y --setopt=install_weak_deps=0 unityhub || {
    echo "::warning::Failed at installing unityhub. Skipping..."
    exit 0
}
