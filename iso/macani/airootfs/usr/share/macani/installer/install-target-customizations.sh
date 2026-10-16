#!/usr/bin/env bash
set -Eeuo pipefail

payload=/run/macani/packages
if (( EUID != 0 )); then
    echo 'MacAni target customization must run as root inside the installed target.' >&2
    exit 1
fi
if [[ ! -d "$payload" ]]; then
    echo 'MacAni package cache is not mounted into the target; start installation from the MacAni launcher.' >&2
    exit 1
fi

shopt -s nullglob
packages=(
    "$payload"/macani-branding-*.pkg.tar.zst
    "$payload"/macani-fastfetch-*.pkg.tar.zst
    "$payload"/aldo-terminal-*.pkg.tar.zst
    "$payload"/macani-liquid-plasma-*.pkg.tar.zst
    "$payload"/macani-gtk-theme-*.pkg.tar.zst
    "$payload"/macani-desktop-*.pkg.tar.zst
)
if (( ${#packages[@]} != 6 )); then
    printf 'Expected six MacAni target packages; found %d in %s.\n' "${#packages[@]}" "$payload" >&2
    exit 1
fi

pacman -U --noconfirm "${packages[@]}"
for package in macani-branding macani-fastfetch aldo-terminal macani-liquid-plasma macani-gtk-theme macani-desktop; do
    pacman -Q "$package" >/dev/null || {
        printf 'Target package installation did not verify: %s\n' "$package" >&2
        exit 1
    }
done

"/usr/bin/macani-apply-desktop-defaults"
printf 'MacAni target packages and safe user defaults installed. Live-session autologin was not installed.\n'
