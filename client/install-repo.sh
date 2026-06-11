#!/bin/bash
# Configura il repository APT SysLinuxOS-Tools su un sistema client.
# Installa la chiave pubblica e la sorgente apt, poi aggiorna l'indice.
#
# Uso:  sudo ./install-repo.sh
set -euo pipefail

REPO_URL="https://fconidi.github.io/SysLinuxOS-Tools"
KEYRING="/usr/share/keyrings/syslinuxos-archive-keyring.gpg"
SOURCES="/etc/apt/sources.list.d/syslinuxos-tools.sources"

if [ "$(id -u)" -ne 0 ]; then
    echo "Esegui come root:  sudo $0" >&2
    exit 1
fi

echo "==> Scarico e installo la chiave pubblica in $KEYRING"
# La chiave armored e' pubblicata nella root del repo.
tmp="$(mktemp)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_URL/syslinuxos-archive-keyring.asc" -o "$tmp"
else
    wget -qO "$tmp" "$REPO_URL/syslinuxos-archive-keyring.asc"
fi
gpg --dearmor < "$tmp" > "$KEYRING"
chmod 0644 "$KEYRING"
rm -f "$tmp"

echo "==> Scrivo la sorgente apt in $SOURCES"
cat > "$SOURCES" <<EOF
X-Repolib-Name: SysLinuxOS-Tools
Types: deb
URIs: $REPO_URL
Suites: tirreno
Components: main
Architectures: amd64
Signed-By: $KEYRING
EOF

echo "==> apt update"
apt-get update

echo
echo "Fatto. Repository SysLinuxOS-Tools configurato."
echo "Pacchetti disponibili: distroclone, distroclone-backup, grub-btrfs,"
echo "syslinuxos-ring-conky, syslinuxos-snapshots."
