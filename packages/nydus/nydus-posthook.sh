#!/usr/bin/bash

# Check if /etc/containers/storage.conf exists
if [ ! -f /etc/containers/storage.conf ]; then
    cp /usr/share/containers/storage.conf /etc/containers/storage.conf
fi

# Add nydus to additionalimagestores
sed -i 's|^additionalimagestores = \[|&\n"/var/lib/nydus-store/store:ref",|' /etc/containers/storage.conf
