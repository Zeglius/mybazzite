#!/usr/bin/env -S bash -euo pipefail

trap 'skip_on_err "Error installing unityhub"' ERR

dnf5 install -y --setopt=install_weak_deps=0 bindfs

canon_dest=/var/opt/unityhub
dest=/usr/share/factory/${canon_dest##/}
mkdir -p "$dest"

bindfs -o allow_other "${dest%%/unityhub}" /opt

trap 'umount /opt' EXIT

sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo'
dnf5 install -y --setopt=install_weak_deps=0 unityhub

# Write a tmpfile entry
# See https://www.freedesktop.org/software/systemd/man/257/tmpfiles.d.html#L
cat >/usr/lib/tmpfiles.d/unityhub.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
L+     $canon_dest  -     -     -      -    $dest

EOF
