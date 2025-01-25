#!/usr/bin/env -S bash -euo pipefail

trap 'skip_on_err "Couldnt setup RPM tooling"' ERR

dnf5 install -y --setopt=install_weak_deps=0 rpmdevtools mock
