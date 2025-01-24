#!/usr/bin/env bash

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null &&
    dnf5 install -y --setopt=install_weak_deps=0 code
