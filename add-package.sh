#!/bin/bash
# Add one or more .deb packages to the SysLinuxOS-Tools repository,
# regenerating and re-signing the indices (reprepro). Then commit and push.
#
# Usage:  ./add-package.sh path/to/package.deb [other.deb ...]
set -euo pipefail

BASE="$(cd "$(dirname "$0")" && pwd)"
SUITE="tirreno"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 package1.deb [package2.deb ...]" >&2
    exit 1
fi

for deb in "$@"; do
    [ -f "$deb" ] || { echo "File not found: $deb" >&2; exit 1; }
    echo "==> includedeb $(basename "$deb")"
    # --ignore=forbiddenchar intentionally NOT used: package names must be
    # lowercase (Debian Policy). If reprepro rejects a .deb, fix its control.
    reprepro -b "$BASE" includedeb "$SUITE" "$deb"
done

echo
echo "==> Repository status:"
reprepro -b "$BASE" list "$SUITE"

echo
echo "To publish the changes:"
echo "  cd \"$BASE\" && git add -A && git commit -m 'repo: update packages' && git push"
