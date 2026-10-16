# Upstream compatibility and redistribution review

| Review field | Record |
|---|---|
| Date and scope | Reviewed 2026-10-14. Twenty unique projects were cloned shallowly into the ignored `build-work/upstream-review/` workspace; the duplicate Dandadan entry was counted once. |
| Snapshot policy | Each matrix row names the inspected short commit ID and the latest version tag visible through `git ls-remote --tags` during the review; commit and tag-page URLs are in the source list. |
| Execution boundary | Upstream READMEs, release data, dependencies, licenses, and installer entry points were inspected. No upstream installer, build script, or system-changing command was executed. |

## MacAni baseline and integration decisions

The Liquid KDE README targets Plasma 6.6/6.7+, which supports considering its static widget-theme assets on the observed Plasma 6.7.5 build; this is compatibility evidence, not visual validation.[1]

| Local compatibility input | Observed value or limitation |
|---|---|
| Candidate ISO packages | Plasma Workspace `6.7.5-3`, Qt 6 Base `6.12.0-2`, and SDDM `0.21.0-7`, from the local Pacman database. |
| GTK runtime | GTK 3/4 runtime packages were not present in the inspected ISO; no GTK application was available for rendering tests. Static assets are selected from the upstream MacTahoe theme.[2] |
| Base lifecycle | Arch is rolling rather than version-pinned; rebuilds can resolve newer package versions, so re-check the ISO package database after each build. |

| Desktop layer | Selected behavior | Scope and limits |
|---|---|---|
| Plasma | `macani-liquid-plasma` packages the upstream Dark and Light widget styles; new users default to Dark. | Only 94 files from the two `plasma-theme` directories. The two `metadata.desktop` files carry dated modification notices; their upstream wallpaper associations are removed. The complete GPL-3 license and provenance note ship in the package. This is a Plasma widget theme, not a dock, global menu, app theme, or complete Liquid Glass shell.[1] |
| GTK | `macani-gtk-theme` packages only GTK 3/4 from the upstream MacTahoe Dark release archive; new users select it in both GTK settings files.[2] | GTK 2, GNOME Shell, Cinnamon, window-manager themes, Plank, Unity, installers, and other variants are excluded. The MIT notice ships with the package. No claim is made that GTK rendering was visually tested. |
| SDDM | Use the Qt 6 Breeze greeter theme already supplied by the Arch/KDE packages; the live image explicitly selects `breeze`. | No candidate anime SDDM theme cleared both licensing and compatibility checks.[3][13][15] The included Breeze theme is identified as Qt 6 in its metadata and was present in the candidate ISO. The live-only autologin remains separate from target-system packages. |
| Plymouth | No third-party Plymouth theme is bundled or made default.[18][19][20] | The reviewed collection has per-theme licensing; other candidates contain anime/franchise art or lack verifiable rights. Do not infer asset rights from a code license. |

## Repository-by-repository review

| # | Repository / version snapshot | Purpose, useful features, dependencies and target | License, MacAni compatibility, decision and remaining work |
|---:|---|---|---|
| 1 | [KDE Liquid Glass](https://github.com/lestercorderomurillo/macos-tahoe-liquid-kde) — tag `v0.9.2`; snapshot `fd39558a` [1][21] | Experimental macOS Tahoe-inspired Plasma suite: widget styles, KWin effects, plasmoids, app themes, installer, sounds and Plymouth. README targets Plasma 6.6/6.7+. Static Plasma styles work with the observed Plasma 6.7.5. | Root license is GPL-3; other components have separate notices/licenses and the README cautions against production use. **Integrated selectively** as the two static Plasma theme directories only. Apple-derived wallpaper links, installer, C++/QML components, effects, fonts, sounds, icons, cursors, and Plymouth are excluded. Verify visual polish and future Plasma updates; no dock/top-panel redesign is claimed. |
| 2 | [MacTahoe GTK](https://github.com/vinceliuice/MacTahoe-gtk-theme) — tag `2026-09-10`; snapshot `1e45e19f` [2][22] | macOS-like GTK theme with GTK 3/4 styles plus GNOME Shell, Cinnamon, Metacity, XFWM4 and Plank variants. Source build lists Sass/GLib/XML tooling and optional image utilities; the selected release archive is already rendered. | Root `COPYING` is MIT. GTK 3/4 assets are **integrated** from `release/MacTahoe-Dark.tar.xz`; only those folders plus `index.theme` are shipped. The release notes mention GNOME Shell 48, not an exact GTK minor version. GTK app rendering, light mode and future GTK compatibility remain untested. |
| 3 | [Makima SDDM](https://github.com/Arnau029/Makima-SDDM) — tag `sddm`; snapshot `5c38154e` [3][23] | Anime login theme for SDDM, designed around 1920×1080. README lists SDDM, CJK/Japanese fonts, Qt 5 Graphical Effects and Quick Controls. | No repository license file was present in the inspected tree; README requires Qt 5 modules while MacAni's SDDM is Qt 6. **Rejected**: both redistribution permission and toolkit compatibility are unresolved. |
| 4 | [Omarchy Dandadan](https://github.com/MISTERNEGATIVE21/Omarchy-Dandadan-Theme) — tag `3.0`; snapshot `62faf66b` [4][24] | Omarchy 4 / Hyprland theme for Quickshell or Waybar, with dynamic palettes, app configs and 52 anime wallpapers. | Code declares MIT, but the franchise wallpapers' redistribution rights are not established. It targets Omarchy/Hyprland, not Plasma. **Visual reference only**; no wallpapers, scripts, configs, or installer are copied. |
| 5 | [Rofi-config](https://github.com/NeiKa0s496/Rofi-config) — no version tag; snapshot `cd9ac0cb` [5][25] | Collection of anime Rofi `.rasi` configurations and backgrounds; requires Rofi and manual path editing. | No license file; examples contain author-specific absolute home paths. **Visual reference only**; not a Plasma launcher dependency and not redistributed. |
| 6 | [Touchégg](https://github.com/JoseExposito/touchegg) — tag `2.0.9`; snapshot `93f8a28e` [6][26] | Gesture daemon with configurable touchpad/touchscreen actions; upstream documents an Arch package. | GPL-3.0, but upstream explicitly says Touchégg works only on X11, not Wayland. MacAni supports Wayland sessions, and no X11-only gesture engine is installed by default. **Not integrated**; revisit only with an explicitly X11-scoped optional package and tested KDE actions. |
| 7 | [Attack on Cards](https://github.com/Ruchita1010/attack-on-cards) — no version tag; snapshot `e6b30f2d` [7][27] | React/Vite browser memory-card game; Node/npm build stack, unrelated to the desktop shell. | No license file; game imagery has no redistribution grant recorded. **Reference only**, not bundled. |
| 8 | [Animfetch](https://github.com/Andrew-Velox/animfetch) — tag `v0.2.0`; snapshot `6cb091e1` [8][28] | Rust animated terminal fetch for Linux/macOS; README requires Rust 1.88+ for source builds and offers prebuilt binaries. | MIT. It overlaps MacAni's already-tested Fastfetch startup and introduces a Rust binary/runtime path not needed for the distro. **Optional reference only**; no upstream installer or binary used. |
| 9 | [Omarchy Shinsekai](https://github.com/Madhukumar511/omarchy-shinsekai-theme) — tag `v1.1.0`; snapshot `8fdaeae` [9][29] | Dynamic anime-wallpaper/color system for Omarchy/Hyprland, with scripts for shell, lock screen, notifications and app themes. | Code declares MIT; bundled anime art/wallpapers do not carry verified separate redistribution rights. It is not a Plasma theme. **Visual reference only**; scripts, wallpaper and app configs are excluded. |
| 10 | [Qylock](https://github.com/Darkkal44/qylock) — no version tag; snapshot `f6561e2c` [10][30] | Large SDDM and Quickshell lock-screen collection; Qt 6 declarative/5-compat/SVG and optional multimedia/GStreamer components. | Root GPL-3, but individual themes rely on anime imagery and some fonts whose rights are not cleared for redistribution. **Not bundled**; SDDM/Quickshell assets and their external media are not part of the MacAni package. |
| 11 | [Genshin SDDM](https://github.com/nicefaa6waa/genshin-sddm-theme) — no version tag; snapshot `067378db` [11][31] | Animated Genshin login theme with time-based video backgrounds, music and Qt/QML media dependencies. | Root license is GPL-3, but Genshin artwork, video and music rights are not granted by that code license. Dependencies span Qt 5/6 and GStreamer; the theme is incomplete per its README. **Not bundled**; no installer or media downloaded. |
| 12 | [Plastic Memories SDDM](https://github.com/DeffreusTheda/sddm-plastic-memories) — no version tag; snapshot `7db6b23e` [12][32] | SDDM QML theme using Qt 5 Multimedia, Git LFS and video codecs. | Root GPL-3, but its README explicitly disclaims ownership of the opening video, music and title images. **Rejected for redistribution** despite the code license; the upstream installer was not run. |
| 13 | [Transparent SDDM](https://github.com/takeshi981/transparent-sddm) — tag `v0.1`; snapshot `25d4e9f7` [13][33] | Minimal transparent greeter advertised for SDDM Qt 6 / Plasma 6. | No license file was present. Qt compatibility alone does not grant redistribution rights. **Reference only**, not installed. |
| 14 | [Glyph SDDM](https://github.com/xCaptaiN09/glyph-sddm) — tag `v1.0`; snapshot `1c8f5206` [14][34] | Nothing-inspired QML greeter; README claims Qt 5/6 and lists Qt Quick, SVG and Quick Controls modules. | Code declares MIT, but bundled Ndot/Symbols fonts and background/avatar artwork have no individually verified licenses in the inspected tree. **Not bundled**; no installer executed. |
| 15 | [Hypr SDDM](https://github.com/adior-enigmac/hypr-sddm) — no version tag; snapshot `52fd4a53` [15][35] | Qt 6 QML login theme with dynamic wallpaper color, virtual keyboard and blur; imports Qt Quick Effects and Virtual Keyboard. | Code declares MIT, but bundled Google Sans Flex/fonts and images were not independently cleared. Its installer overwrites SDDM configuration and suggests sudoers access for Matugen; those scripts were not run. **Not bundled** pending asset-license and login/security testing. |
| 16 | [HoloISO SteamOS SDDM](https://github.com/WylfredWen/holoiso-sddm-steamos-theme) — tag `v1.2.0`; snapshot `75d4ca37` [16][36] | Plasma 6 SteamOS-like SDDM theme derived from Sugar Dark. | GPL-3 code, with Steam/Valve imagery and branding subject to separate rights; target is HoloISO. **Visual reference only**; no Valve-styled media is redistributed. |
| 17 | [Frieren Wayland SDDM](https://github.com/dillonbray/sddm-frieren-wayland) — no version tag; snapshot `c833b204` [17][37] | Responsive Qt 6/Wayland greeter; requires SDDM Qt 6 and `qt6-5compat`. | Repository license is GNU Library GPL v2; README says included fonts are OFL, but the QML/background is based on copyrighted Frieren artwork and separate asset notices are not bundled. **Not redistributed**; module availability and theme behavior remain untested. |
| 18 | [Plymouth Themes](https://github.com/adi1090x/plymouth-themes) — tag `v1.0`; snapshot `5d881745` [18][38] | Large collection of image/script Plymouth animations for Arch and other distributions; changing themes requires installing Plymouth and rebuilding the initramfs. | Repository has a GPL-3 notice, but individual theme directories carry their own licenses and assets. **No theme selected**; per-theme rights and initramfs/boot-unlock behavior need separate review before packaging. |
| 19 | [HiTech Arch Animation](https://github.com/xDeFc0nx/HiTech-arch-animation) — no version tag; snapshot `4c029620` [19][39] | Arch-branded Plymouth script animation with 148 frames and a PKGBUILD; requires Plymouth's script plugin. | Root GPL-3, but README still contains placeholder descriptive/preview text and no release tag was visible. **Not integrated**; no initramfs changes or script execution. |
| 20 | [One Piece Plymouth](https://github.com/Anxhul10/onePiece-plymouth) — tag `v0.0.5`; snapshot `ec9358d8` [20][40] | One Piece-themed Plymouth animation with Bash installation/update scripts. | Code declares MIT, but anime imagery is not covered by that grant; scripts modify system theme/initramfs state. **Rejected for distribution**; no assets or scripts copied or run. |

## Installation procedure review

| Procedure-review field | Summary |
|---|---|
| Boundary | README installation instructions and script entry points were inspected. The summaries below describe the upstream administrator path; none was executed. MacAni packages only the explicitly selected static assets described above. |

| # | Upstream installation path reviewed; MacAni safety decision |
|---:|---|
| 1 | The multi-component installer offers selected Plasma/app/window-manager components and can perform system configuration. **Not run**; the MacAni package installs only the two static Plasma theme folders. [1][21] |
| 2 | README instructs `./install.sh` for the full theme pack; source build uses Sass/GLib/XML tools. MacAni uses only GTK 3/4 content from the pre-rendered Dark archive. [2][22] |
| 3 | README's manual path moves the clone to `/usr/share/sddm/themes` and edits SDDM's active theme. No license and Qt 5 requirements block use. [3][23] |
| 4 | Omarchy's theme installer or repository hooks install app configs/wallpapers and alter shell state. Not run; Omarchy/Hyprland is not MacAni's desktop. [4][24] |
| 5 | README asks users to copy `.rasi` configs under `~/.config/rofi`, rename files and edit absolute paths. No license; no files copied. [5][25] |
| 6 | README points Arch users to the distro `touchegg` package or source build instructions. Not installed because upstream says it is X11-only. [6][26] |
| 7 | React/Vite project is a web game; its Node-based demo/build path is not a system theme installer. No license; nothing bundled. [7][27] |
| 8 | README offers a `curl | sh` installer, AUR binary and Cargo source install. No installer or binary executed; Fastfetch remains MacAni's fetch utility. [8][28] |
| 9 | Theme scripts/CLI install Omarchy wallpaper and dynamic-color behavior. Not run; anime wallpaper rights and desktop compatibility are unresolved. [9][29] |
| 10 | Repository exposes SDDM and Quickshell setup scripts for a large theme collection. Not run; no individual anime/font asset was selected. [10][30] |
| 11 | `install-sddm-theme.sh` installs dependencies, downloads large video assets and configures SDDM. Not run; code license does not grant Genshin media rights. [11][31] |
| 12 | `install.sh` downloads video via Git LFS, copies the theme and edits SDDM configuration. Not run; README disclaims rights to embedded audiovisual assets. [12][32] |
| 13 | README's manual path copies the theme to SDDM's theme directory and edits `Current=transparent`. Not run; no license file. [13][33] |
| 14 | README offers an installer/AUR route that copies assets and may configure SDDM. Not run; included fonts and images lack verified separate licenses. [14][34] |
| 15 | `install.sh` selects a Qt branch, replaces installed theme files and can edit SDDM/virtual-keyboard config; Matugen guidance recommends sudoers access. Not run. [15][35] |
| 16 | README directs users to extract a release archive and manually set `Current=holoiso-sddm-steamos`. Not run; Valve-related assets are excluded. [16][36] |
| 17 | README directs users to copy the theme, add SDDM config, then test/restart SDDM. No restart was performed; Qt 6 compatibility and artwork rights are unresolved. [17][37] |
| 18 | README directs users to copy one theme and invoke `plymouth-set-default-theme -R`, rebuilding the initramfs. Not run; each theme needs its own license/asset review. [18][38] |
| 19 | README advertises an AUR package; repository includes a PKGBUILD. It was inspected, not executed; the snapshot has placeholder README/preview text. [19][39] |
| 20 | Repository includes `main.sh`/test scripts for an anime Plymouth theme. They were not run; any theme change/initramfs update is deferred because One Piece artwork rights are not established. [20][40] |

## Verification and remaining limits

| Verification area | Result or remaining limit |
|---|---|
| Package boundaries | `macani-liquid-plasma` and `macani-gtk-theme` are separate Arch packages. Each ships its upstream license and provenance note; the desktop package seeds only missing user defaults. Live-session SDDM autologin remains isolated to `macani-live` and the live image. |
| Liquid Plasma payload | Compared with the pinned Git tree: 47 files per variant, 46 byte-identical files plus one dated, documented metadata adaptation per variant; the full GPL license matches upstream byte-for-byte.[1][21] |
| GTK payload | Extracted only from the pinned MacTahoe Dark release archive after validating paths and relative symlinks; a byte/symlink-target comparison found no mismatches. The GTK 3/4 trees contain 425 files/links total; no upstream installer was run.[2][22] |
| Visual/install coverage | Static profile/package tests and package builds verify payload and metadata, not appearance. GTK rendering, Plasma polish, SDDM hardware testing, physical installation, target first boot, and custom Plymouth behavior remain unverified. |
| Outstanding rights | No upstream SDDM/Plymouth anime artwork, wallpaper, installer, or shell was bundled. Existing MacAni artwork/logo redistribution rights remain separately unresolved; see [`packages/LICENSE-STATUS.md`](../packages/LICENSE-STATUS.md). |

## Sources

[1] https://github.com/lestercorderomurillo/macos-tahoe-liquid-kde/commit/fd39558a3cf676845459c8d7c8ef770bca8e1c76
[2] https://github.com/vinceliuice/MacTahoe-gtk-theme/commit/1e45e19f510edb8cde18fa84d6cd5319f60b086b
[3] https://github.com/Arnau029/Makima-SDDM/commit/5c38154e50c0c144e94790ba6a01f760e52108fd
[4] https://github.com/MISTERNEGATIVE21/Omarchy-Dandadan-Theme/commit/62faf66b9acd34684c40895d18bb915acdda81af
[5] https://github.com/NeiKa0s496/Rofi-config/commit/cd9ac0cba44fd738c3e6e5dcbd7c0e00ab8fee63
[6] https://github.com/JoseExposito/touchegg/commit/93f8a28e37b87568f439f6c4c616c907fbbf4a33
[7] https://github.com/Ruchita1010/attack-on-cards/commit/e6b30f2d4be30e5a0dd6884b1735490c8d3c2de8
[8] https://github.com/Andrew-Velox/animfetch/commit/6cb091e14c3a67da05a6ea036b295f0cfd97ce63
[9] https://github.com/Madhukumar511/omarchy-shinsekai-theme/commit/8fdaeaeed5a6901499ba933c7c503ae432d4263e
[10] https://github.com/Darkkal44/qylock/commit/f6561e2ceae33f26e5e660742a5df2f725cbe514
[11] https://github.com/nicefaa6waa/genshin-sddm-theme/commit/067378dbc0bf501a72ac4a98a8a78b3822a534b5
[12] https://github.com/DeffreusTheda/sddm-plastic-memories/commit/7db6b23e3f6313c990f6894020061bc6597d98ca
[13] https://github.com/takeshi981/transparent-sddm/commit/25d4e9f769da816467e2f8f7adec99d976343f22
[14] https://github.com/xCaptaiN09/glyph-sddm/commit/1c8f52064335908dc2ca8ac11691f1d55bfbc188
[15] https://github.com/adior-enigmac/hypr-sddm/commit/52fd4a538fabea2331d9b9f956c2497ff5f9102c
[16] https://github.com/WylfredWen/holoiso-sddm-steamos-theme/commit/75d4ca37cb295c77b996536e701ccecaacd895eb
[17] https://github.com/dillonbray/sddm-frieren-wayland/commit/c833b20410f005b8f030e2d14cdadcbe0f7cc999
[18] https://github.com/adi1090x/plymouth-themes/commit/5d8817458d764bff4ff9daae94cf1bbaabf16ede
[19] https://github.com/xDeFc0nx/HiTech-arch-animation/commit/4c029620cff2763badd61423749c50626c22b500
[20] https://github.com/Anxhul10/onePiece-plymouth/commit/ec9358d88e82367ba252781491654717605c719e
[21] https://github.com/lestercorderomurillo/macos-tahoe-liquid-kde/tags
[22] https://github.com/vinceliuice/MacTahoe-gtk-theme/tags
[23] https://github.com/Arnau029/Makima-SDDM/tags
[24] https://github.com/MISTERNEGATIVE21/Omarchy-Dandadan-Theme/tags
[25] https://github.com/NeiKa0s496/Rofi-config/tags
[26] https://github.com/JoseExposito/touchegg/tags
[27] https://github.com/Ruchita1010/attack-on-cards/tags
[28] https://github.com/Andrew-Velox/animfetch/tags
[29] https://github.com/Madhukumar511/omarchy-shinsekai-theme/tags
[30] https://github.com/Darkkal44/qylock/tags
[31] https://github.com/nicefaa6waa/genshin-sddm-theme/tags
[32] https://github.com/DeffreusTheda/sddm-plastic-memories/tags
[33] https://github.com/takeshi981/transparent-sddm/tags
[34] https://github.com/xCaptaiN09/glyph-sddm/tags
[35] https://github.com/adior-enigmac/hypr-sddm/tags
[36] https://github.com/WylfredWen/holoiso-sddm-steamos-theme/tags
[37] https://github.com/dillonbray/sddm-frieren-wayland/tags
[38] https://github.com/adi1090x/plymouth-themes/tags
[39] https://github.com/xDeFc0nx/HiTech-arch-animation/tags
[40] https://github.com/Anxhul10/onePiece-plymouth/tags
