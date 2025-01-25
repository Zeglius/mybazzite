#!/usr/bin/env -S bash -euo pipefail

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

curl -sSLo "$tmpdir"/rustover.tar.gz https://download.jetbrains.com/rustrover/RustRover-2024.3.3.tar.gz
tar -xaf "$tmpdir"/rustover.tar.gz -C "$dest" --strip-components=1

# Write a tmpfile entry
# See https://www.freedesktop.org/software/systemd/man/257/tmpfiles.d.html#L
cat >/usr/lib/tmpfiles.d/rustover.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
L+     $canon_dest  -     -     -      -    $dest

EOF
