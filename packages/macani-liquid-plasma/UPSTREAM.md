# Curated upstream content

- Project: https://github.com/lestercorderomurillo/macos-tahoe-liquid-kde
- Snapshot commit: `fd39558a3cf676845459c8d7c8ef770bca8e1c76` (2026-10-13); source README identifies Plasma 6.6/6.7+.
- Upstream license: GPL-3.0 as stated in the root `LICENSE` and theme metadata; the full license is preserved as `LICENSE.upstream` and installed by the package.
- Included only `src/offline/plasma-theme/MacTahoeLiquidKde-Dark/` and `src/offline/plasma-theme/MacTahoeLiquidKde-Light/` (94 static files).
- Excluded the upstream installer, custom C++ plasmoids, KWin effects, GTK theme, icons/cursors, fonts, sounds, Apple-derived wallpapers, Plymouth theme, and SDDM theme.
- Adaptation: removed the `[Wallpaper]` association from each upstream `metadata.desktop`; MacAni continues to select its own wallpaper. No other upstream theme files are modified.
- This theme is a partial Plasma style only. It does not provide a dock, top panel, application styles, SDDM, or bootloader theme. The upstream README calls the overall project experimental; MacAni has not visually certified this theme.
