#!/usr/bin/env -S bash -euo pipefail

dnf5 autoremove -y
dnf5 clean all
rm -rf /var/cache/libdnf5

(
	cd /var
	find . -print0 | xargs -r0 rm -rf || :
)

(
	shopt -s nullglob
	echo /tmp/* | xargs -r rm -rf || true
)
