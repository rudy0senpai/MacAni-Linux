#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
profile="$repo_root/iso/macani"

usage() {
    cat <<USAGE
Usage: ${0##*/} [--help]
Run static checks on the MacAni Archiso profile, installer presets, and package payloads.
USAGE
}
case "${1:-}" in
    -h|--help) usage; exit 0 ;;
    '') ;;
    *) usage >&2; exit 2 ;;
esac

errors=0
scripts=(
    "$profile/airootfs/usr/local/bin/macani-live-user-setup"
    "$profile/airootfs/usr/local/bin/macani-live-diagnostics"
    "$profile/airootfs/usr/local/bin/macani-installer"
    "$profile/airootfs/usr/local/bin/aldo"
    "$profile/airootfs/usr/local/bin/macani-apply-desktop-defaults"
    "$profile/airootfs/usr/share/macani/installer/install-target-customizations.sh"
)
for script in "${scripts[@]}"; do
    if [[ ! -x "$script" ]]; then
        printf 'ERROR: missing or non-executable script: %s\n' "${script#"$repo_root"/}" >&2
        errors=$((errors + 1))
        continue
    fi
    if ! bash -n "$script"; then
        printf 'ERROR: bash syntax check failed: %s\n' "${script#"$repo_root"/}" >&2
        errors=$((errors + 1))
    fi
done

pkgbuilds=(
    "$repo_root/packages/macani-branding/PKGBUILD"
    "$repo_root/packages/macani-desktop/PKGBUILD"
    "$repo_root/packages/macani-live/PKGBUILD"
    "$repo_root/packages/macani-fastfetch/PKGBUILD"
    "$repo_root/packages/aldo-terminal/PKGBUILD"
    "$repo_root/packages/macani-liquid-plasma/PKGBUILD"
    "$repo_root/packages/macani-gtk-theme/PKGBUILD"
)
for pkgbuild in "${pkgbuilds[@]}"; do
    if [[ ! -f "$pkgbuild" ]]; then
        printf 'ERROR: package recipe missing: %s\n' "${pkgbuild#"$repo_root"/}" >&2
        errors=$((errors + 1))
    elif ! bash -n "$pkgbuild"; then
        printf 'ERROR: package recipe syntax check failed: %s\n' "${pkgbuild#"$repo_root"/}" >&2
        errors=$((errors + 1))
    fi
done

service="$profile/airootfs/etc/systemd/system/macani-live-user.service"
link="$profile/airootfs/etc/systemd/system/multi-user.target.wants/macani-live-user.service"
[[ -f "$service" ]] || { echo 'ERROR: live-user unit missing' >&2; errors=$((errors + 1)); }
# Accept a real symlink OR a plain file whose content is the relative target
# (Windows checkouts cannot store symlinks and check them out as target text).
if [[ -L "$link" ]]; then
    target=$(readlink "$link")
elif [[ -f "$link" ]]; then
    target=$(cat "$link")
else
    target=""
fi
if [[ "$target" != "../macani-live-user.service" ]]; then
    echo 'ERROR: live-user unit enablement link is missing or incorrect' >&2
    errors=$((errors + 1))
fi
grep -q '^Before=display-manager\.service$' "$service" || {
    echo 'ERROR: live-user service is not ordered before the display manager' >&2
    errors=$((errors + 1))
}
grep -q 'Name=Install MacAni Linux' "$profile/airootfs/usr/share/applications/macani-installer.desktop" || {
    echo 'ERROR: installer application-menu entry missing' >&2
    errors=$((errors + 1))
}
for package in archinstall kitty fish fastfetch chafa ttf-jetbrains-mono; do
    grep -qx "$package" "$profile/packages.x86_64" || {
        printf 'ERROR: %s missing from x86_64 package list\n' "$package" >&2
        errors=$((errors + 1))
    }
done
for recipe in macani-branding macani-fastfetch aldo-terminal macani-liquid-plasma macani-gtk-theme macani-desktop; do
    [[ -f "$repo_root/packages/$recipe/PKGBUILD" ]] || {
        printf 'ERROR: installer package recipe missing: %s\n' "$recipe" >&2
        errors=$((errors + 1))
    }
done
sddm_theme_dir="$profile/airootfs/usr/share/sddm/themes/macani"

# --- SDDM macani theme integration (replaces the old Breeze-only check) ---
if [[ ! -d "$sddm_theme_dir" ]]; then
    echo "ERROR: SDDM theme directory missing: $sddm_theme_dir" >&2
    errors=$((errors + 1))
fi
for file in Main.qml theme.conf metadata.desktop logo.png; do
    if [[ ! -f "$sddm_theme_dir/$file" ]]; then
        echo "ERROR: SDDM theme asset missing: $file" >&2
        errors=$((errors + 1))
    fi
done
if ! grep -qx 'Current=macani' "$profile/airootfs/etc/sddm.conf.d/20-macani-theme.conf"; then
    echo 'ERROR: SDDM theme is not selected as macani' >&2
    errors=$((errors + 1))
fi
# Ensure no other sddm.conf.d entry overrides the theme selection.
for conf in "$profile/airootfs/etc/sddm.conf.d/"*; do
    if [[ -f "$conf" ]] && ! grep -qx 'Current=macani' "$conf"; then
        echo "ERROR: unexpected sddm.conf.d entry: $(basename "$conf")" >&2
        errors=$((errors + 1))
    fi
done
# Required SDDM packages and services.
grep -qx 'sddm' "$profile/packages.x86_64" || {
    echo 'ERROR: sddm missing from x86_64 package list' >&2
    errors=$((errors + 1))
}
[[ -f "$profile/airootfs/etc/systemd/system/display-manager.service" ]] || {
    echo 'ERROR: display-manager.service missing' >&2
    errors=$((errors + 1))
}
grep -q '/usr/lib/systemd/system/sddm.service' "$profile/airootfs/etc/systemd/system/display-manager.service" || {
    echo 'ERROR: display-manager.service does not point to sddm' >&2
    errors=$((errors + 1))
}
[[ -f "$profile/airootfs/etc/systemd/system/macani-live-user.service" ]] || {
    echo 'ERROR: macani-live-user.service missing' >&2
    errors=$((errors + 1))
}
grep -q '^Before=display-manager\.service$' "$profile/airootfs/etc/systemd/system/macani-live-user.service" || {
    echo 'ERROR: live-user service is not ordered before the display manager' >&2
    errors=$((errors + 1))
}
grep -qx 'name=MacTahoeLiquidKde-Dark' "$profile/airootfs/etc/skel/.config/plasmarc" || {
    echo 'ERROR: default Plasma theme is not the curated Liquid Glass style' >&2
    errors=$((errors + 1))
}
for version in 3.0 4.0; do
    settings="$profile/airootfs/etc/skel/.config/gtk-$version/settings.ini"
    grep -qx 'gtk-theme-name=MacTahoe-Dark' "$settings" || {
        printf 'ERROR: GTK %s default theme is missing or incorrect\n' "$version" >&2
        errors=$((errors + 1))
    }
done
for version in 3.0 4.0; do
    [[ -f "$profile/airootfs/usr/share/themes/MacTahoe-Dark/gtk-$version/gtk.css" ]] || {
        printf 'ERROR: GTK %s theme assets are missing\n' "$version" >&2
        errors=$((errors + 1))
    }
done
repo_root_win=$(cygpath -w "$repo_root" 2>/dev/null || printf '%s' "$repo_root")
python3 - "$repo_root_win/iso/macani/airootfs/usr/share/macani/installer/archinstall.json" <<'PY' || errors=$((errors + 1))
import json, pathlib, sys
p = sys.argv[1]
if not pathlib.Path(p).exists():
    print("ERROR: archinstall.json not found: %s" % p, file=sys.stderr)
    sys.exit(1)
config=json.loads(pathlib.Path(p).read_text())
assert config["bootloader_config"]["bootloader"] == "Grub"
assert config["bootloader_config"]["uki"] is False
assert "/run/macani/install-target-customizations.sh" in config["custom_commands"]
assert {"kitty", "fish", "fastfetch"}.issubset(config["packages"])
PY

if [[ $errors -ne 0 ]]; then
    printf 'Profile validation failed (%d issue(s)).\n' "$errors" >&2
    exit 1
fi
printf 'Profile validation passed: scripts, package declarations, Plasma/GTK defaults, macani SDDM theme, Archinstall GRUB preset, and live-service ordering.\n'
bash "$repo_root/tools/test-aldo-fastfetch.sh"
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "${scripts[@]}" "$repo_root/tools/build-packages.sh" "$repo_root/tools/build-iso.sh"
else
    echo 'NOTE: ShellCheck not installed; skipped.'
fi
if command -v fish >/dev/null 2>&1; then
    fish -n "$profile/airootfs/etc/fish/conf.d/90-macani-fastfetch.fish"
else
    echo 'NOTE: fish not installed in build environment; Fish syntax check deferred to ISO.'
fi
if command -v systemd-analyze >/dev/null 2>&1; then
    systemd-analyze --root="$profile/airootfs" verify /etc/systemd/system/macani-live-user.service
else
    echo 'NOTE: systemd-analyze not installed; skipped.'
fi
