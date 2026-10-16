#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
stage_root="$repo_root/build-work/package-stage"
mkdir -p -- "$stage_root"

stage_one() {
    local pkgname=$1
    local stage="$stage_root/$pkgname"
    mkdir -p -- "$stage"
    (
        cd -- "$repo_root/packages/$pkgname"
        startdir=$PWD
        pkgdir=$stage
        source ./PKGBUILD
        package
    )
    printf 'Staged %s payload under %s\n' "$pkgname" "${stage#"$repo_root"/}"
}

for package in macani-branding macani-fastfetch aldo-terminal macani-desktop macani-liquid-plasma macani-gtk-theme macani-live; do
    stage_one "$package"
done

for expected in \
    "$stage_root/macani-branding/usr/share/color-schemes/MacAni-Sakura.colors" \
    "$stage_root/macani-branding/usr/share/backgrounds/macani/froppy.jpg" \
    "$stage_root/macani-branding/usr/share/pixmaps/macani/MacAni-Linux_logo.png" \
    "$stage_root/macani-fastfetch/etc/fastfetch/macani-kitty.jsonc" \
    "$stage_root/macani-fastfetch/etc/fastfetch/macani-fallback.jsonc" \
    "$stage_root/aldo-terminal/usr/bin/aldo" \
    "$stage_root/aldo-terminal/etc/xdg/kitty/kitty.conf" \
    "$stage_root/aldo-terminal/etc/fish/conf.d/90-macani-fastfetch.fish" \
    "$stage_root/macani-desktop/usr/bin/macani-apply-desktop-defaults" \
    "$stage_root/macani-desktop/etc/skel/.config/gtk-3.0/settings.ini" \
    "$stage_root/macani-desktop/etc/skel/.config/gtk-4.0/settings.ini" \
    "$stage_root/macani-liquid-plasma/usr/share/plasma/desktoptheme/MacTahoeLiquidKde-Dark/metadata.desktop" \
    "$stage_root/macani-liquid-plasma/usr/share/plasma/desktoptheme/MacTahoeLiquidKde-Light/metadata.desktop" \
    "$stage_root/macani-liquid-plasma/usr/share/licenses/macani-liquid-plasma/LICENSE" \
    "$stage_root/macani-gtk-theme/usr/share/themes/MacTahoe-Dark/gtk-3.0/gtk.css" \
    "$stage_root/macani-gtk-theme/usr/share/themes/MacTahoe-Dark/gtk-4.0/gtk.css" \
    "$stage_root/macani-gtk-theme/usr/share/licenses/macani-gtk-theme/LICENSE" \
    "$stage_root/macani-live/usr/local/bin/macani-live-user-setup" \
    "$stage_root/macani-live/usr/lib/systemd/system/macani-live-user.service" \
    "$stage_root/macani-live/usr/share/macani/installer/archinstall.json"; do
    [[ -f "$expected" ]] || { printf 'ERROR: expected package payload missing: %s\n' "$expected" >&2; exit 1; }
done
printf 'Package payload staging checks passed. Build archives separately with tools/build-packages.sh.\n'
