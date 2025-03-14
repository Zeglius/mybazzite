#!/usr/bin/env -S bash -euo pipefail

# Skip, simply install with toolbox
exit 0

on_err() {
	echo "::warning::Couldnt setup Rustover. Skipping..."
	exit 0
}

trap 'on_err' ERR

canon_dest=/var/opt/Rustover
dest=/usr/share/factory/${canon_dest##/}
mkdir -p "$dest"

tmpdir=$(mktemp -d)
trap 'rm -vrf $tmpdir' EXIT

VERSION="2024.3.4"

curl -sSLo "$tmpdir"/rustover.tar.gz https://download.jetbrains.com/rustrover/RustRover-"$VERSION".tar.gz
tar -xaf "$tmpdir"/rustover.tar.gz -C "$dest" --strip-components=1

# Write a tmpfile entry
# See https://www.freedesktop.org/software/systemd/man/257/tmpfiles.d.html#L
cat >/usr/lib/tmpfiles.d/rustover.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
L+     $canon_dest  -     -     -      -    $dest

EOF
