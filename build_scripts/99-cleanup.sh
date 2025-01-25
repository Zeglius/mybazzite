#!/usr/bin/env -S bash -euo pipefail

dnf5 remove -y bindfs || true
dnf5 clean all
rm -rf /var/cache/libdnf5
(
    shopt -s nullglob
    { echo /tmp/* | xargs -r rm -rf; } || true
)
