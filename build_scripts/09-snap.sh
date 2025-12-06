#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup snap"' ERR

dnf install -yq snapd

# Ensure /snap directory exists and is writable
rm -rf /snap
ln -s /var/lib/snapd/snap /snap
systemctl enable snap.mount

cat >/usr/lib/tmpfiles.d/snap-bootc-writable.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
d      /var/snap   755   root  root   -
EOF

trap - ERR
