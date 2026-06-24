#!/bin/bash
# Configure the SysLinuxOS-Tools APT repository on a client system.
# Installs the public key and the apt source, then updates the index.
#
# Usage:  sudo ./install-repo.sh
set -euo pipefail

REPO_URL="https://fconidi.github.io/SysLinuxOS-Tools"
KEYRING="/usr/share/keyrings/syslinuxos-archive-keyring.gpg"
SOURCES="/etc/apt/sources.list.d/syslinuxos-tools.sources"
PREFS="/etc/apt/preferences.d/99-syslinuxos-tools.pref"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root:  sudo $0" >&2
    exit 1
fi

echo "==> Downloading and installing the public key into $KEYRING"
# The armored key is published in the repo root.
tmp="$(mktemp)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_URL/syslinuxos-archive-keyring.asc" -o "$tmp"
else
    wget -qO "$tmp" "$REPO_URL/syslinuxos-archive-keyring.asc"
fi
gpg --dearmor < "$tmp" > "$KEYRING"
chmod 0644 "$KEYRING"
rm -f "$tmp"

echo "==> Writing the apt source to $SOURCES"
cat > "$SOURCES" <<EOF
X-Repolib-Name: SysLinuxOS-Tools
Types: deb
URIs: $REPO_URL
Suites: tirreno
Components: main
Architectures: amd64
Signed-By: $KEYRING
EOF

echo "==> Writing the apt pin to $PREFS (grub-btrfs: always prefer the SysLinuxOS build)"
cat > "$PREFS" <<'EOF'
# grub-btrfs: always force the SysLinuxOS build (override of the Debian one),
# even if Debian offers a numerically higher version.
Package: grub-btrfs
Pin: release o=SysLinuxOS
Pin-Priority: 1001
EOF

echo "==> apt update"
apt-get update

echo
echo "Done. SysLinuxOS-Tools repository configured."
echo "Available packages: distroclone, distroclone-backup, grub-btrfs,"
echo "syslinuxos-ring-conky, syslinuxos-snapshots."
