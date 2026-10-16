#!/usr/bin/env bash
set -Eeuo pipefail
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
profile="$repo_root/iso/macani"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

for package in kitty fish fastfetch chafa ttf-jetbrains-mono; do
    grep -qx "$package" "$profile/packages.x86_64" || fail "missing live package $package"
done
for path in \
    "$profile/airootfs/usr/local/bin/aldo" \
    "$profile/airootfs/etc/xdg/kitty/kitty.conf" \
    "$profile/airootfs/etc/fish/conf.d/90-macani-fastfetch.fish" \
    "$profile/airootfs/etc/fastfetch/macani-kitty.jsonc" \
    "$profile/airootfs/etc/fastfetch/macani-fallback.jsonc" \
    "$profile/airootfs/usr/share/pixmaps/macani/MacAni-Linux_logo.png"; do
    [[ -f "$path" ]] || fail "missing required Aldo/logo asset: ${path#"$repo_root"/}"
done
bash -n "$profile/airootfs/usr/local/bin/aldo"
python3 - "$profile/airootfs/etc/fastfetch/macani-kitty.jsonc" "$profile/airootfs/etc/fastfetch/macani-fallback.jsonc" "$profile/airootfs/usr/share/pixmaps/macani/MacAni-Linux_logo.png" <<'PY'
import json, pathlib, struct, sys
for config in sys.argv[1:3]:
    data=json.loads(pathlib.Path(config).read_text())
    assert data["modules"] and data["logo"]["source"].endswith("MacAni-Linux_logo.png")
assert json.loads(pathlib.Path(sys.argv[1]).read_text())["logo"]["type"] == "kitty-direct"
assert json.loads(pathlib.Path(sys.argv[2]).read_text())["logo"]["type"] == "chafa"
image=pathlib.Path(sys.argv[3]).read_bytes()
assert image[:8] == b"\x89PNG\r\n\x1a\n" and image[25] == 6, "official image must remain RGBA PNG"
print("Aldo, Fastfetch configurations, and RGBA logo checks passed.")
PY
