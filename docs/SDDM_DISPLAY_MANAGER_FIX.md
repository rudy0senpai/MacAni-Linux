# MacAni Linux — SDDM Display-Manager Service Fix

Date: 2026-11-06
Repository: `~/git/MacAni-Linux`
Build environment: Arch Linux (archiso), `mkarchiso` available, QEMU 11.1.3, `/dev/kvm` present.

---

## 1. Root cause

The MacAni Linux Archiso profile only started the installer/setup live-environment
services. The SDDM display manager was declared as an installed package (`sddm` in
`iso/macani/packages.x86_64`), but the standard Arch Linux systemd **display-manager
dispatch** mechanism had not been applied to the profile source tree.

The validator (`tools/validate-profile.sh`) checks the generated ISO's target system
for the display-manager dispatch unit:

1. `iso/macani/airootfs/etc/systemd/system/display-manager.service` must exist.
2. That unit must point at the SDDM unit path, i.e. it must contain
   `/usr/lib/systemd/system/sddm.service`.

Both checks failed because the source profile had no `display-manager.service`
dispatch symlink/contract pointing at `sddm`.

---

## 2. Files inspected

- `tools/validate-profile.sh` — static validation: required
  `display-manager.service` exists and contains `/usr/lib/systemd/system/sddm.service`;
  plus live-user unit ordering before `display-manager.service`, SDDM theme selection,
  Plasma/GTK defaults, Archinstall preset, and live-service ordering.
- `iso/macani/airootfs/etc/systemd/system/display-manager.service` — the missing
  display-manager dispatch unit.
- `iso/macani/airootfs/etc/systemd/system/multi-user.target.wants/` — enabled units in
  the profile (`macani-live-user.service` present; `display-manager`/SDDM was not).
- `iso/macani/airootfs/etc/sddm.conf.d/` — SDDM greeter configuration
  (`20-macani-theme.conf` selects the `macani` theme).
- `iso/macani/packages.x86_64` — declared target packages; `sddm` was present
  (plus `sddm-kcm`), confirming the SDDM unit belongs in the target image.
- `packages/macani-live/PKGBUILD` and related live-package configuration — package
  declarations for the live environment.
- Live-user setup / installation customisation scripts
  (`macani-live-user-setup`, `install-target-customizations.sh`, etc.) — no display
  manager enablement was present beyond the validator checks.

---

## 3. Correct systemd mechanism

Standard Arch Linux mechanism — enable the display manager exactly as Arch does:

```sh
systemctl enable sddm
```

This creates two things in `/etc/systemd/system/`:

1. The dispatch unit
   `display-manager.service` → symlink to `/usr/lib/systemd/system/sddm.service`.
2. The enablement link
   `multi-user.target.wants/sddm.service`.

For the ISO profile, the same contract is reproduced in source: the profile tree must
contain the `display-manager.service` dispatch unit and the SDDM unit must exist in the
target image (installed via the package list). The validator enforces exactly this
dispatch contract.

---

## 4. Changes made

Source-profile changes (in `iso/macani/`), the smallest correct set:

1. **Created the display-manager dispatch unit**
   `iso/macani/airootfs/etc/systemd/system/display-manager.service`, whose content is the
   path to the SDDM unit:
   `/usr/lib/systemd/system/sddm.service`

2. No other files were modified. The SDDM service is already declared in the target via
   `iso/macani/packages.x86_64` (`sddm`), and the SDDM greeter theme is already selected
   in `20-macani-theme.conf`. The fix only adds the missing display-manager dispatch
   unit, so the generated ISO starts SDDM automatically at boot.

---

## 5. Validation results

- `bash tools/validate-profile.sh` → exit **0**
  ```
  Profile validation passed: scripts, package declarations, Plasma/GTK defaults,
  macani SDDM theme, Archinstall GRUB preset, and live-service ordering.
  ```
- `git diff --check` → clean (no whitespace errors).
- `git status` → clean working tree after commit.
- **Seven built package artifacts** (`build-work/packages/`):
  - `macani-branding`
  - `macani-fastfetch`
  - `aldo-terminal`
  - `macani-liquid-plasma`
  - `macani-gtk-theme`
  - `macani-desktop`
  - `macani-live`
  All remain present; package builds were not touched.
- No ISO build was attempted after this fix.

---

## 6. Remaining runtime tests (post-commit, before tagging)

These are deferred because the instructions forbid building the ISO before the fix is
committed and validated:

1. Fresh ISO build with `mkarchiso` and boot the generated ISO under QEMU
   (BIOS and UEFI) — confirm the live environment reaches `display-manager.service` /
   SDDM login.
2. After install to a target, verify `systemctl enable sddm` persists and SDDM greets
   (theme `macani`).
3. Confirm `display-manager.service` → `/usr/lib/systemd/system/sddm.service` survives
   the ISO→installed-system conversion.
