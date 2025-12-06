#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup snap"' ERR

dnf install -yq snapd

# Ensure /snap directory exists and is writable
mkdir -p /snap
cat <<EOF >/usr/lib/systemd/system/snap.mount
# Workaround for snapd in Fedora atomic bootc
# 
# This ensures we have a writable /snap directory

[Unit]
Description=Bind mount /var/snap on /snap
Before=snapd.mounts-pre.target
DefaultDependencies=no
After=systemd-remount-fs.service
Before=local-fs.target

[Mount]
What=/var/snap
Where=/snap
Options=bind,rw

[Install]
WantedBy=local-fs.target
EOF
systemctl enable snap.mount

cat >/usr/lib/tmpfiles.d/snap-bootc-writable.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
d      /var/snap   755   root  root   -
EOF

trap - ERR
