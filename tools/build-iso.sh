#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
profile="$repo_root/iso/macani"
work_dir="$repo_root/build-work"
out_dir="$repo_root/out"
package_dir=${MACANI_PACKAGE_DIR:-"$repo_root/build-work/packages"}

usage() {
    cat <<USAGE
Usage: sudo ${0##*/} [--help]
Build the MacAni Archiso profile using isolated work and output directories.
First run tools/build-packages.sh as an unprivileged user.
Environment overrides: MACANI_WORK_DIR, MACANI_OUT_DIR, MACANI_PACKAGE_DIR
USAGE
}
case "${1:-}" in
    -h|--help) usage; exit 0 ;;
    '') ;;
    *) usage >&2; exit 2 ;;
esac

if (( EUID != 0 )); then
    echo 'ERROR: mkarchiso must run as root. Re-run this wrapper with sudo.' >&2
    exit 1
fi
command -v mkarchiso >/dev/null 2>&1 || { echo 'ERROR: mkarchiso is not installed.' >&2; exit 1; }
work_dir=${MACANI_WORK_DIR:-$work_dir}
out_dir=${MACANI_OUT_DIR:-$out_dir}
work_dir=$(realpath -m -- "$work_dir")
out_dir=$(realpath -m -- "$out_dir")
package_dir=$(realpath -m -- "$package_dir")
for candidate in "$work_dir" "$out_dir" "$package_dir"; do
    if [[ "$candidate" == "$profile" || "$candidate" == "$profile/"* || "$profile" == "$candidate/"* ]]; then
        printf 'ERROR: build directories may not overlap the Archiso profile: %s\n' "$candidate" >&2
        exit 2
    fi
done
if [[ "$work_dir" == "$out_dir" || "$work_dir" == "$out_dir/"* || "$out_dir" == "$work_dir/"* ]]; then
    echo 'ERROR: work and output directories must be separate and non-overlapping.' >&2
    exit 2
fi

required=(macani-branding macani-fastfetch aldo-terminal macani-liquid-plasma macani-gtk-theme macani-desktop)
archives=()
shopt -s nullglob
for package in "${required[@]}"; do
    matches=("$package_dir/$package-"*.pkg.tar.zst)
    if (( ${#matches[@]} != 1 )); then
        printf 'ERROR: expected one built archive for %s in %s; run tools/build-packages.sh first.\n' "$package" "$package_dir" >&2
        exit 1
    fi
    archives+=("${matches[0]}")
done

stage_dir="$profile/airootfs/usr/share/macani/installer/packages"
if [[ -e "$stage_dir" ]]; then
    echo "ERROR: refusing to overwrite existing package staging directory: $stage_dir" >&2
    exit 1
fi
mkdir -p -- "$work_dir" "$out_dir" "$stage_dir"
staged_archives=()
cleanup() {
    local archive
    for archive in "${staged_archives[@]:-}"; do
        [[ -n "$archive" ]] && rm -f -- "$archive"
    done
    rmdir -- "$stage_dir" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
for archive in "${archives[@]}"; do
    destination="$stage_dir/$(basename -- "$archive")"
    staged_archives+=("$destination")
    cp -- "$archive" "$destination"
done

mkarchiso -v -w "$work_dir" -o "$out_dir" "$profile" 2>&1 | tee "$out_dir/macani-archiso.log"
