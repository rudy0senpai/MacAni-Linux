#!/usr/bin/env bash
set -euo pipefail
PROFILE="${1:-iso/macani}"
ROOTFS="$PROFILE/airootfs"
if [[ ! -d "$PROFILE" || ! -d "$ROOTFS" ]]; then
  echo "Usage: $0 [path/to/iso-profile]" >&2
  echo "Expected an Archiso profile containing airootfs/: $PROFILE" >&2
  exit 2
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
cp -a "$SCRIPT_DIR/rootfs/." "$ROOTFS/"
echo "Installed MacAni anime assets into $ROOTFS"
echo "These assets will be present in the ISO; they are not installed into the current WSL desktop."
