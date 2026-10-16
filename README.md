# MacAni Linux 🌸

MacAni Linux is an experimental Archiso/KDE Plasma distribution with MacAni Sakura colors, anime artwork, the user-provided MacAni emblem, a branded Kitty/Fish terminal, and a real guided Arch installer.

## Current scope

- Archiso profile: `iso/macani/` (x86_64 package list plus an existing aarch64 list).
- KDE Plasma, SDDM, Dolphin, Konsole, Kate, Sakura color/sound defaults, character icons, and project wallpapers. New users receive the curated Liquid KDE Plasma widget theme plus the MacTahoe GTK 3/4 theme; the live greeter explicitly uses Qt 6 Breeze.
- Live-only `macani` user setup and SDDM autologin. It detects a Plasma session file installed in the image and writes `/etc/sddm.conf.d/10-macani-live.conf` at boot.
- **Aldo**, launched by command and application entry, uses Kitty with Fish. KDE's default terminal application is set to Aldo. If Kitty cannot start, the launcher tries Konsole, then Fish.
- Fastfetch is configured to use the original MacAni logo. Kitty uses the Kitty graphics protocol; other terminals use Chafa's colored text rendering. Fish startup is interactive-only, excluded from SSH, and guarded against nested-shell repeats. Disable it for a user with `set -Ux MACANI_NO_FASTFETCH 1`.
- The guided installer is Archinstall's supported TUI. Its config recommends GRUB and keeps Archinstall's real bootloader selector: rEFInd is UEFI-only and is hidden in legacy BIOS mode. The selected bootloader and destination layout are handled by Archinstall. MacAni's six target packages are installed after the base target install through Archinstall's post-install custom command. The live-only account/autologin package is excluded from that target transaction.

## Aldo and visual design

Kitty was selected over Alacritty because its Kitty graphics protocol lets Fastfetch render the original PNG directly, it supports OpenGL rendering and tabs, and its Arch package supports X11/Wayland. Arch package metadata at build time reports Kitty 0.49.2-1 at 19.13 MiB download / 76.70 MiB installed; Alacritty 0.17.0-1 is also GPU-accelerated and much smaller at 2.48 MiB / 8.30 MiB. The choice prioritizes the direct-image feature, not a performance claim. No comparative benchmark or Intel HD 5500 graphical test has been run. See the [Kitty graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/) and [Alacritty project](https://alacritty.org/) references.

Aldo uses JetBrains Mono, a cyan/blue/teal/purple palette, and 92% Kitty background opacity. Transparency depends on a working compositor; blur is not forced, and Konsole remains installed as a fallback. The existing colors, icons, wallpaper, and sounds add MacAni identity, but this is **not yet a complete Liquid Glass shell**: there is no verified macOS-style dock/top-panel layout, broad per-application styling, custom SDDM theme, or custom installed-system bootloader theme. Do not treat opacity as proof that KWin blur is active.

The uploaded original `MacAni-Linux_logo.png` is copied without modification to `/usr/share/pixmaps/macani/MacAni-Linux_logo.png`, included by `macani-branding`, and referenced by both Fastfetch configurations. It is a 1315×1196 RGBA PNG with full/partial alpha transparency; its SHA-256 matches the upload. No derivative replaces the original.

## Packages

- `macani-branding`: logo, wallpapers, icon, color, and sound assets.
- `macani-fastfetch`: versioned JSON configuration for Kitty and Chafa.
- `aldo-terminal`: Aldo launcher, Kitty defaults, Fish startup integration, desktop entry.
- `macani-desktop`: KDE skeleton defaults and safe user-default application script.
- `macani-live`: live-only provisioning/SDDM and installer launcher/configuration. Never install this package into the normal target system.

Build packages and ISO in separate steps:

```bash
./tools/validate-profile.sh
./tools/test-packages.sh
./tools/build-packages.sh       # ordinary user; makepkg/fakeroot required
namcap build-work/packages/*.pkg.tar.zst  # when namcap is installed
sudo ./tools/build-iso.sh       # root; requires archiso
```

`build-packages.sh` writes untracked archives under `build-work/packages/`. The ISO wrapper temporarily stages the six non-live packages in the image for Archinstall, refuses to overwrite a pre-existing staging directory, captures `out/macani-archiso.log`, and removes its staged package copies on exit. ISO output is under `out/`, work files under `build-work/`. Override with `MACANI_WORK_DIR`, `MACANI_OUT_DIR`, or `MACANI_PACKAGE_DIR`; keep work/output separate and outside the Archiso profile. Build from a current Arch Linux environment with `base-devel`, `archiso`, sufficient disk space, and network access for repository packages.

Package recipes use `LicenseRef-MacAni` as a project-local marker. It is **not** an open-source license grant. The repository currently lacks complete provenance/licensing for the pre-existing artwork/audio and the uploaded logo, and has no top-level source-code license. See [`packages/LICENSE-STATUS.md`](packages/LICENSE-STATUS.md) and the [20-project upstream compatibility and redistribution review](docs/upstream-review.md); obtain and record all remaining rights before publishing or redistributing the ISO/packages.

## Installer and bootloader details

Choose **Install MacAni Linux** from the application menu. The launcher refuses to run outside an Archiso session. It starts Archinstall with Plasma/desktop/terminal packages, NetworkManager and SDDM services, GRUB as the default bootloader recommendation, and the MacAni post-install package command. Archinstall asks for target disk, partitions, locale/timezone, users, and other installation choices; inspect the selected disk and formatting actions before confirming. This workflow requires repository/network access for Arch packages.

The Archinstall version in the inspected build includes actual GRUB and rEFInd bootloader choices. Its implementation marks rEFInd UEFI-only and omits it on BIOS; it installs/configures the selected option rather than adding a cosmetic selector. No installation was run on development disks. Calamares is not in the configured official repositories, so the current installer is a terminal UI, not a graphical installer. There is no custom bootloader theme yet.

The installed target receives `macani-branding`, `macani-fastfetch`, `aldo-terminal`, `macani-liquid-plasma`, `macani-gtk-theme`, and `macani-desktop` as local Pacman packages; Fish becomes the login shell for regular installed users while root retains its recovery shell. Desktop defaults seed only missing user config files. Live SDDM autologin is separate and is not included in the target package transaction.

## Validation and live-session diagnostics

```bash
bash -n iso/macani/airootfs/usr/local/bin/macani-live-user-setup
./tools/validate-profile.sh
./tools/test-packages.sh
./tools/build-packages.sh
namcap build-work/packages/*.pkg.tar.zst
```

`tools/validate-profile.sh` checks script/PKGBUILD syntax, package declarations, Fastfetch JSON and RGBA logo structure, Archinstall GRUB preset, Plasma/GTK skeleton settings and theme assets, Breeze SDDM configuration, executable flags, systemd ordering, and the live-user enablement symlink. It runs ShellCheck, Fish syntax validation, and `systemd-analyze verify` when installed. `tools/test-packages.sh` exercises PKGBUILD `package()` staging for the seven local packages; `build-packages.sh` produces actual Arch package archives.

`macani-live-diagnostics` prints live user/session/SDDM/service state and relevant journal entries. The live setup service is a root oneshot, ordered before `display-manager.service`, safe to rerun, and not configured for a restart loop. It creates the `macani` user only when absent, preserves existing home files, uses Fish when present (Bash fallback), and sets SDDM's session name from the installed Plasma `.desktop` file.

## Remaining verification

An earlier candidate ISO, built before the latest GTK/SDDM profile changes, booted in both BIOS and UEFI-mode QEMU VMs (KVM acceleration, 4 GiB RAM, read-only ISO, **no virtual disk**) and reached the Plasma desktop through live SDDM autologin. UEFI logged a non-fatal `systemd-loop@…sr0.service` failure while attaching the virtual CD-ROM. That older image does **not** verify the newly added GTK package/assets or Breeze config. The latest profile validation and package staging tests passed, and the seven package archives built successfully, but a fresh ISO build and boot remain outstanding. Still unverified: GTK rendering in a real app, Liquid Plasma visual polish, latest-image SDDM behavior, Kitty's graphical logo/transparency, Archinstall UI and actual target installation, installed-system first boot, and physical hardware. No installation or partition changes were made. The build does not resolve unknown rights for pre-existing artwork/audio/logo; obtain rights before redistribution.

### WSL note

Use the native WSL path `/home/dhruv/MacAni-Linux`. Windows UNC traversal mishandles Linux symlink/reparse entries in this checkout and has produced false Git status and I/O errors; native WSL Git is authoritative. The service enablement entry is a relative symlink to `../macani-live-user.service`.
