#!/usr/bin/env -S bash -euo pipefail
{
    curl -sSLO https://download.jetbrains.com/rustrover/RustRover-2024.3.3.tar.gz | tar -xa -C "$(realpath /opt)"
} || {
    echo "::warning::Couldnt setup Rustover. Skipping..."
    exit 0
}
