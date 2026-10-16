# Changelog

## Unreleased — 2026-10-14

- Preserved the supplied 1315×1196 RGBA MacAni logo byte-for-byte and integrated it into branding/Fastfetch.
- Added Aldo (Kitty/Fish), terminal colors, safe interactive-only Fastfetch startup, Chafa rendering fallback, and KDE's default-terminal preference.
- Added curated `macani-liquid-plasma` and `macani-gtk-theme` packages. Liquid KDE integration is limited to Dark/Light Plasma widget-theme assets; GTK integration is limited to MacTahoe GTK 3/4 Dark assets. Both retain upstream license/provenance files. New users receive defaults only when their own settings do not already exist.
- Selected Qt 6 Breeze for the live SDDM greeter. Anime/franchise SDDM and Plymouth artwork, upstream installers, and unknown-license components were not redistributed or executed.
- Added a cited compatibility, licensing, release, dependency, and installation-procedure audit of 20 unique upstream repositories in [`docs/upstream-review.md`](docs/upstream-review.md). Added executable package/build/validation tools and safe local-package staging for the image/Archinstall target.
- The target post-install transaction handles six non-live packages; `macani-live` remains excluded from target installs and retains live-only autologin.
- Latest profile validation, Aldo/Fastfetch checks, and package payload tests passed; all seven local Arch packages built. ShellCheck and Fish syntax checks were skipped because those tools are unavailable in the build environment.
- An earlier candidate ISO passed xorriso inspection and BIOS/UEFI QEMU booted to Plasma, but that image predates the latest GTK/SDDM changes. A fresh ISO build and boot are required to verify this update.
- Remaining limits: GTK rendering, Plasma visual polish, latest-image SDDM behavior, real Archinstall target install/first boot, and physical hardware are unverified. Rights for pre-existing anime art/audio and the user-supplied logo remain unresolved; obtain permission before redistribution. No full Liquid Glass shell/dock, custom SDDM artwork, or installed bootloader theme is claimed.
