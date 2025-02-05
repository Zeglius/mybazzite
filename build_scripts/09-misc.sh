#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup miscellanea stuff"' ERR

echo "::group::Setup podman testing"
dnf5 -y --repo=updates-testing swap podman podman
echo "::endgroup::"
