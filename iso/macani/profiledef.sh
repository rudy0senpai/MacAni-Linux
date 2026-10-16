#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="macani-linux"
iso_label="MACANI_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="MacAni Linux Project"
iso_application="MacAni Linux Live Desktop"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86,arm64' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
kernel_params_aarch64="clk_ignore_unused pd_ignore_unused arm64.nopauth"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/macani-live-user-setup"]="0:0:755"
  ["/usr/local/bin/macani-live-diagnostics"]="0:0:755"
  ["/usr/local/bin/macani-installer"]="0:0:755"
  ["/usr/local/bin/aldo"]="0:0:755"
  ["/usr/local/bin/macani-apply-desktop-defaults"]="0:0:755"
  ["/usr/share/macani/installer/install-target-customizations.sh"]="0:0:755"
  ["/etc/skel/Desktop/Install-MacAni-Linux.desktop"]="0:0:755"
)
