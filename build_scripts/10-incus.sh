#!/usr/bin/env -S bash -euo pipefail

set -x
trap 'skip_on_err "Couldnt setup incus"' ERR

dnf install -yq incus incus-tools incus-client

trap - ERR
