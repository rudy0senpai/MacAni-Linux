#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
package_dir=${MACANI_PACKAGE_DIR:-"$repo_root/build-work/packages"}

usage() {
    cat <<USAGE
Usage: ${0##*/} [--help]
Build all local MacAni Arch packages as the current unprivileged user.
Output directory: MACANI_PACKAGE_DIR or build-work/packages.
USAGE
}
case "${1:-}" in
    -h|--help) usage; exit 0 ;;
    '') ;;
    *) usage >&2; exit 2 ;;
esac
if (( EUID == 0 )); then
    echo 'ERROR: makepkg must not run as root; run this script as an ordinary user.' >&2
    exit 1
fi
command -v makepkg >/dev/null 2>&1 || { echo 'ERROR: makepkg is not installed.' >&2; exit 1; }
mkdir -p -- "$package_dir"
package_dir=$(realpath -m -- "$package_dir")

for package in macani-branding macani-fastfetch aldo-terminal macani-liquid-plasma macani-gtk-theme macani-desktop macani-live; do
    printf 'Building %s...\n' "$package"
    (
        cd -- "$repo_root/packages/$package"
        PKGDEST="$package_dir" makepkg --clean --force --nodeps --noconfirm --nosign
    )
done

for package in macani-branding macani-fastfetch aldo-terminal macani-liquid-plasma macani-gtk-theme macani-desktop macani-live; do
    shopt -s nullglob
    artifacts=("$package_dir/$package-"*.pkg.tar.zst)
    (( ${#artifacts[@]} == 1 )) || {
        printf 'ERROR: expected one archive for %s, found %d.\n' "$package" "${#artifacts[@]}" >&2
        exit 1
    }
done
printf 'Built and verified seven local Arch packages in %s.\n' "$package_dir"
