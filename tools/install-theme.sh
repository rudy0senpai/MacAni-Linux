#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$ROOT/plymouth/macani"
DEST="/usr/share/plymouth/themes/macani"

sudo install -d "$DEST"
sudo install -m 644 "$THEME/macani.plymouth" "$THEME/macani.script" "$THEME/background.png" "$THEME/logo.png" "$DEST/"
sudo install -d "$DEST/frames" "$DEST/progress"
sudo cp -a "$THEME/frames/." "$DEST/frames/" 2>/dev/null || true
sudo cp -a "$THEME/progress/." "$DEST/progress/" 2>/dev/null || true

echo "Theme files installed to $DEST"
echo "Next: inspect /etc/mkinitcpio.conf and your bootloader before enabling Plymouth."
