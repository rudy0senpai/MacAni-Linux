# MacAni Linux — Anime asset pack

This bundle is staged for the Archiso profile at `iso/macani/airootfs`. It contains:

- 69 optimized widescreen wallpapers from the uploaded asset archive.
- 30 PNG character/custom icons, exposed as the optional `MacAni-Characters` icon theme (inherits Breeze).
- 14 Ogg Vorbis desktop sound effects under `MacAni-Sakura`.
- `MacAni-Sakura.colors`, a KDE color scheme (not a full Plasma Global Theme).
- Optional AnimeKeyboard Qt Virtual Keyboard style files from the supplied archive. The keyboard wrapper is not enabled by default.

## Install into the MacAni Archiso profile

From the root of your `MacAni-Linux` repository, extract this archive, then run:

```bash
cp -a macani-anime-assets/rootfs/. iso/macani/airootfs/
```

If the extracted directory name differs, adjust the source path. This copies assets into the ISO's live root filesystem. It does not install a theme into your current WSL desktop.

## Important

- The uploaded archive did not contain a complete Plasma Global Theme or a complete system icon theme; this bundle adds a KDE color scheme and a character-icon collection.
- The optional AnimeKeyboard style is a Qt Virtual Keyboard style. To use it in the live ISO, include the appropriate `plasma-keyboard` package and configure the wrapper separately.
- Review the licenses/permissions of all anime artwork and audio before redistributing an ISO publicly. The original archive did not provide complete licensing metadata.
