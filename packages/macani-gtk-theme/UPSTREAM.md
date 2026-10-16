# Curated upstream content

- Project: https://github.com/vinceliuice/MacTahoe-gtk-theme
- Snapshot commit: `1e45e19f510edb8cde18fa84d6cd5319f60b086b` (2026-09-28); latest observed tag is `2026-09-10`; the pinned commit contains `release/MacTahoe-Dark.tar.xz`.
- Upstream `COPYING` is the MIT license; it is preserved as `LICENSE.upstream` and installed by the package.
- Included only the `gtk-3.0/`, `gtk-4.0/`, and `index.theme` payload from `release/MacTahoe-Dark.tar.xz`. GTK 2, GNOME Shell, Cinnamon, Metacity, XFWM4, Plank, Unity, installer scripts, and other color variants are excluded.
- The release archive reports GNOME Shell 48; it does not state an exact GTK minor version. MacAni ships the static GTK 3/4 theme, with the dark variant selected for new users. The current ISO has not been verified to include GTK applications or runtimes, so theme rendering on a real GTK app remains untested.
- No upstream installer or theme-generation script was executed. Four same-directory relative SVG links are preserved as provided.
