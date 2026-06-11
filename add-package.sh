#!/bin/bash
# Aggiunge uno o piu' pacchetti .deb al repository SysLinuxOS-Tools,
# rigenera e ri-firma gli indici (reprepro). Poi resta da committare/pushare.
#
# Uso:  ./add-package.sh percorso/pacchetto.deb [altro.deb ...]
set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
SUITE="tirreno"

if [ "$#" -lt 1 ]; then
    echo "Uso: $0 pacchetto1.deb [pacchetto2.deb ...]" >&2
    exit 1
fi

for deb in "$@"; do
    [ -f "$deb" ] || { echo "File non trovato: $deb" >&2; exit 1; }
    echo "==> includedeb $(basename "$deb")"
    # --ignore=forbiddenchar NON usato di proposito: i nomi pacchetto devono
    # essere minuscoli (Debian Policy). Se reprepro rifiuta, correggi il control.
    reprepro -b "$BASE" includedeb "$SUITE" "$deb"
done

echo
echo "==> Stato repository:"
reprepro -b "$BASE" list "$SUITE"

echo
echo "Per pubblicare le modifiche:"
echo "  cd \"$BASE\" && git add -A && git commit -m 'repo: aggiorno pacchetti' && git push"
