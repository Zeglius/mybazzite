#!/usr/bin/env -S bash -euo pipefail

trap 'skip_on_err "Couldnt setup Jetbrains toolbox"' ERR

SOURCE="https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.5.2.35332.tar.gz"

EXIT_TRAP=''
trap 'eval $EXIT_TRAP' EXIT

canon_dest=/var/opt/Jetbrains_toolbox
dest=/usr/share/factory/${canon_dest##/}

tmpdir=$(mktemp -d)
EXIT_TRAP="${EXIT_TRAP:-:}; rm -rf $tmpdir"

curl -sSLo "$tmpdir/jetbrains-toolbox.tar.gz" "$SOURCE"
tar -xaf "$tmpdir/jetbrains-toolbox.tar.gz" -C "$tmpdir" --strip-components=1

if [[ ! -f "$tmpdir/jetbrains-toolbox" ]]; then
	echo >&2 "jetbrains-toolbox appimage not found"
	exit 1
fi

pushd "$tmpdir"
./jetbrains-toolbox --appimage-extract
mkdir -p "$dest" && mv -T squashfs-root "$dest"
popd

# Write a tmpfile entry
# See https://www.freedesktop.org/software/systemd/man/257/tmpfiles.d.html#L
cat >/usr/lib/tmpfiles.d/unityhub.conf <<EOF
#Type  Path         Mode  User  Group  Age  Argument…
L+     $canon_dest  -     -     -      -    $dest

EOF
