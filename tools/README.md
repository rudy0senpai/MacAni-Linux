# MacAni Linux Splash Theme — implementation starter

This package contains:
- `plymouth/macani/`: Plymouth theme source and logo/background.
- `login/sddm/`: optional SDDM QML visual layer (not a complete greeter theme).
- `install-theme.sh`: copies Plymouth assets into `/usr/share/plymouth/themes/macani/`.

## 1. Install

From this folder:

```bash
chmod +x install-theme.sh
./install-theme.sh
```

Install Plymouth on Arch/CachyOS if needed:

```bash
sudo pacman -S plymouth
```

## 2. Test before enabling at boot

```bash
sudo plymouthd
sudo plymouth --show-splash
# Close test:
sudo plymouth --quit
```

If the preview fails, inspect:
```bash
sudo journalctl -b | grep -i plymouth
```

## 3. Configure initramfs (Arch/CachyOS — manual and cautious)

Back up first:
```bash
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.macani-backup
```

Edit `/etc/mkinitcpio.conf` and add `plymouth` to `HOOKS`.
Typical ordering is `... udev plymouth ...`; do not blindly replace your existing hooks.
Then rebuild:
```bash
sudo mkinitcpio -P
```

## 4. Configure GRUB (only if GRUB is your bootloader)

Back up:
```bash
sudo cp /etc/default/grub /etc/default/grub.macani-backup
```

In `GRUB_CMDLINE_LINUX_DEFAULT`, add:
```
quiet splash
```
Keep existing parameters. Regenerate GRUB config (Arch):
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

For systemd-boot, do **not** run grub-mkconfig; edit the relevant loader entry and add `quiet splash` to its options line.

## 5. SDDM login animation

`login/sddm/Main.qml` is a visual background/branding layer, not a complete SDDM theme. SDDM themes replace the greeter UI, so integration depends on the installed theme and SDDM version. Back up the active SDDM theme and merge the background/logo animation into its `Main.qml`; don't replace the greeter blindly.

To identify your display manager:
```bash
systemctl status display-manager
readlink -f /etc/systemd/system/display-manager.service
```

## Safety / rollback

- Keep a known-good boot entry.
- Do not remove `quiet`/`splash` or change boot parameters until preview works.
- If boot becomes graphical/blank, use GRUB's fallback entry or TTY/recovery, restore `/etc/mkinitcpio.conf.macani-backup`, rebuild `sudo mkinitcpio -P`, and restore `/etc/default/grub.macani-backup` if changed.
- This starter is a visual prototype; Plymouth script APIs vary by version. Verify the preview before making it the default.
