#!/usr/bin/env bash

dnf5 clean all
rm -rf /var/cache/libdnf5

(
    shopt -s nullglob
    for f in /tmp/*; do
        rm -rf "$f"
    done
)
