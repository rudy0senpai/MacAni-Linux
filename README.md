# MacAni Linux 🌸

An anime-inspired Linux distribution based on Arch Linux and Archiso, featuring KDE Plasma and a macOS-inspired desktop.

## Features

- Arch Linux live ISO built with Archiso
- KDE Plasma desktop
- MacAni-Sakura color scheme
- 69 anime wallpapers
- Anime character icon theme
- MacAni-Sakura system sound theme
- NetworkManager and graphical login configuration

## Project status

**Experimental — Work in Progress**

The ISO has built successfully. Live-session startup, hardware compatibility, and the final desktop layout still require testing on physical hardware.

## Requirements

- Arch Linux build environment
- Archiso
- Internet connection for package downloads
- Sufficient disk space for the ISO and build workspace

## Build from source

Install Archiso:

```bash
sudo pacman -S --needed archiso
```

Build the ISO from the project root:

```bash
sudo mkarchiso -v -w "$PWD/work" -o "$PWD/out" "$PWD/iso/macani"
```

The resulting ISO will be written to `out/`.

## Testing

Test the ISO in a virtual machine or boot it from a USB drive before attempting installation. Back up important data before changing internal disk partitions.

## Contributing

Suggestions, bug reports, and contributions are welcome. Include relevant build logs when reporting problems.
