# MacAni Linux SDDM greeter — source layout
#
# This directory holds the source of the SDDM 0.21.0 liquid-glass login theme.
# The files here are the maintainable sources; the complete theme is installed
# into the Archiso profile at:
#
#   iso/macani/airootfs/usr/share/sddm/themes/macani/
#
# The installed theme directory is the SDDM theme lookup path for the
# "macani" greeter selected via /etc/sddm.conf.d/* with:
#
#   [Theme]
#   Current=macani
#
# Required files in the installed theme directory:
#   theme.conf        — [General] section with theme settings.
#   Main.qml          — the greeter scene (see below).
#   metadata.desktop  — SDDM greeter metadata.
#   logo.png          — official MacAni emblem (referenced by theme.conf).
#
# Main.qml uses only the SDDM 0.21.0 SddmComponents QML module and the SDDM
# greeter context properties/slots:
#   - SddmComponents: TextBox, PasswordBox, ComboBox, LayoutBox, Button,
#     PictureBox, TextConstants.
#   - Context properties: sddm (proxy), sessionModel, userModel, screenModel,
#     keyboard, config.
#   - sddm API: sddm.login(user, password, sessionIndex), the
#     loginSucceeded/loginFailed/informationMessage signals, the sddm.can*
#     capabilities, and sddm.powerOff()/reboot()/suspend()/hibernate().
#
# No external network requests or dependencies are used.

[Theme]
Current=macani
Name=MacAni Linux
Author=MacAni Linux
Information=MacAni liquid-glass SDDM greeter for SDDM 0.21.0
