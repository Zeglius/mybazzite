#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup snap"' ERR

dnf install -yq snapd

rm -rf /snap
ln -sf /var/snap /snap

cat >/usr/lib/tmpfiles.d/unityhub.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
d      /var/snap   755   root  root   -
EOF

trap - ERR
