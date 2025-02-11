#!/usr/bin/env -S bash -euo pipefail
set -x
trap 'skip_on_err "Error installing unityhub"' ERR

canon_dest=/var/opt/unityhub
dest=/usr/share/factory/${canon_dest##/}

mkdir -p /var/opt /usr/share/factory/var/opt

sh -c 'echo -e "[unityhub]\nname=Unity Hub\nbaseurl=https://hub.unity3d.com/linux/repos/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://hub.unity3d.com/linux/repos/rpm/stable/repodata/repomd.xml.key\nrepo_gpgcheck=1" > /etc/yum.repos.d/unityhub.repo'
dnf5 install -y --setopt=install_weak_deps=0 unityhub

mv -T "$canon_dest" "$dest" 

dnf5 config-manager setopt unityhub.enabled=0

# Write a tmpfile entry
# See https://www.freedesktop.org/software/systemd/man/257/tmpfiles.d.html#L
cat >/usr/lib/tmpfiles.d/unityhub.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
C+     $canon_dest  -     -     -      -    $dest

EOF
