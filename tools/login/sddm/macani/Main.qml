/***************************************************************************
 * MacAni Linux — SDDM 0.21.0 liquid-glass login theme
 *
 * A fully functional greeter for SDDM 0.21.0.
 *
 * Visual:
 *   Dark navy "liquid-glass" canvas with cyan / blue / violet / subtle
 *   magenta gradient bloom. Semi-transparent glass panels, cyan and violet
 *   accents, and the official MacAni emblem.
 *
 * Functionality:
 *   - Username entry (with user selector) and password entry.
 *   - Session selection from installed desktop sessions (wayland+x11).
 *   - Keyboard layout selector (when more than one layout is installed).
 *   - Real authentication through the SDDM "sddm" proxy:
 *       sddm.login(user, password, sessionIndex)
 *     with loginSucceeded / loginFailed / informationMessage handling.
 *   - Login submission on Button click and on Enter in the password field.
 *   - Shutdown / reboot / suspend / hibernate controls (guarded by the
 *     sddm.can* capabilities).
 *   - Responsive layout for any resolution and aspect ratio.
 *   - No external network requests or dependencies.
 *
 * Reference: SDDM 0.21.0 shipped SddmComponents QML module and the
 * "maya" theme convention from the SDDM upstream tree
 * (components/2.0 + components/common).
 *
 * Assets:
 *   logo.png  — official MacAni emblem (relative path from the theme dir).
 *   A QML-only abstract gradient background is used so no large binary
 *   artwork is required.
 *
 * License: see the project root / packages/LICENSE-STATUS.md for the
 * user-supplied logo usage terms.
 ***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    anchors.fill: parent
    clip: true

    LayoutMirroring.enabled: true
    LayoutMirroring.childrenInherit: true

    // ------------------------------------------------------------------
    // Shared text strings and screen geometry.
    // ------------------------------------------------------------------
    TextConstants {
        id: textConstants
    }

    // ------------------------------------------------------------------
    // Authentication state and wiring to the SDDM daemon.
    // ------------------------------------------------------------------
    property string statusMessage: ""

    // Derived values used by the QML logic below.
    property alias sessionIndex: sessionField.index

    Connections {
        target: sddm

        function onLoginSucceeded() {
            busy.visible = false
            root.statusMessage = ""
        }

        function onLoginFailed() {
            busy.visible = false
            root.statusMessage = textConstants.loginFailed
        }

        function onInformationMessage(message) {
            busy.visible = false
            root.statusMessage = message
        }
    }

    // ------------------------------------------------------------------
    // Background: liquid-glass navy canvas (QML-only gradient, no binary
    // artwork required).
    // ------------------------------------------------------------------
    Rectangle {
        id: backdrop
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.00; color: "#050817" }
            GradientStop { position: 0.45; color: "#0c1c3e" }
            GradientStop { position: 0.75; color: "#12103a" }
            GradientStop { position: 1.00; color: "#1a103a" }
        }

        // Soft cyan-to-magenta bloom over the whole canvas.
        Rectangle {
            anchors.fill: parent
            opacity: 0.16
            gradient: Gradient {
                GradientStop { position: 0.00; color: "#22d3ee" }
                GradientStop { position: 0.55; color: "#6366f1" }
                GradientStop { position: 1.00; color: "#a78bfa" }
            }
            transform: Rotate {
                angle: 0
            }
        }
    }

    // ------------------------------------------------------------------
    // MacAni emblem (official logo).
    // ------------------------------------------------------------------
    PictureBox {
        id: logo
        source: "logo.png"
        width: Math.min(root.width * 0.22, 240)
        height: width * (1196 / 1315)
        fillMode: PictureBox.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -150
        opacity: 0
        scale: 0.8
        Behavior on opacity {
            NumberAnimation { duration: 900; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 1000; easing.type: Easing.OutBack }
        }
        Component.onCompleted: {
            opacity = 1
            scale = 1
        }
    }

    // ------------------------------------------------------------------
    // Product title.
    // ------------------------------------------------------------------
    Text {
        id: title
        text: textConstants.welcomeText.arg("MacAni Linux")
        color: "#f4f7ff"
        font.family: "Noto Sans"
        font.pixelSize: Math.min(root.width * 0.045, 36)
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: logo.bottom
        anchors.topMargin: 20
        anchors.margins: 0
    }

    // ------------------------------------------------------------------
    // Main login panel (user, password, session, layout, submit).
    // ------------------------------------------------------------------
    Column {
        id: panel
        anchors.top: title.bottom
        anchors.topMargin: title.y >= 0 ? 28 : 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: bottomControls.top
        anchors.bottomMargin: 24
        spacing: 16

        // --- Username ---
        Row {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Column {
                width: Math.min(root.width * 0.55, 280)
                spacing: 4

                Text {
                    text: textConstants.userName
                    color: "#9fb2d4"
                    font.family: "Noto Sans"
                    font.pixelSize: Math.min(root.width * 0.028, 16)
                }

                TextBox {
                    id: usernameField
                    width: parent.width
                    font.pixelSize: Math.min(root.width * 0.032, 20)
                    color: "#e8ecf6"
                    focus: true
                    Keys.onReturn: {
                        if (passwordField.focus) return
                        submitLogin()
                    }
                }
            }

            // --- Password ---
            Column {
                width: Math.min(root.width * 0.55, 280)
                spacing: 4

                Text {
                    text: textConstants.password
                    color: "#9fb2d4"
                    font.family: "Noto Sans"
                    font.pixelSize: Math.min(root.width * 0.028, 16)
                }

                PasswordBox {
                    id: passwordField
                    width: parent.width
                    font.pixelSize: Math.min(root.width * 0.032, 20)
                    color: "#e8ecf6"
                    focus: true
                    Keys.onReturn: {
                        submitLogin()
                    }
                }
            }
        }

        // --- Session selector ---
        Row {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Column {
                width: Math.min(root.width * 0.55, 280)
                spacing: 4

                Text {
                    text: textConstants.session
                    color: "#9fb2d4"
                    font.family: "Noto Sans"
                    font.pixelSize: Math.min(root.width * 0.028, 16)
                }

                ComboBox {
                    id: sessionField
                    model: sessionModel
                    font.pixelSize: Math.min(root.width * 0.032, 18)
                    color: "#e8ecf6"
                    index: sessionModel.lastIndex
                    // defer model binding until sessionModel is populated
                    property bool ready: false
                    Component.onCompleted: { ready = true }
                }
            }

            // --- Keyboard layout ---
            Column {
                width: Math.min(root.width * 0.45, 260)
                spacing: 4
                visible: keyboard.enabled && keyboard.layouts.length > 0

                Text {
                    text: textConstants.layout
                    color: "#9fb2d4"
                    font.family: "Noto Sans"
                    font.pixelSize: Math.min(root.width * 0.028, 16)
                }

                LayoutBox {
                    id: layoutField
                    font.pixelSize: Math.min(root.width * 0.032, 18)
                }
            }
        }

        // --- Login button ---
        Row {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Rectangle {
                id: loginButton
                width: Math.min(root.width * 0.42, 360)
                height: 46
                radius: 8
                border.color: "#6366f1"
                border.width: 1.5
                opacity: busy.visible ? 0.55 : 1

                gradient: Gradient {
                    GradientStop { position: 0.00; color: "#1e3a8a" }
                    GradientStop { position: 0.50; color: "#1e40af" }
                    GradientStop { position: 1.00; color: "#312e81" }
                }

                Text {
                    anchors.centerIn: parent
                    text: textConstants.login
                    font.pixelSize: Math.min(root.width * 0.032, 20)
                    font.bold: true
                    color: "#f4f7ff"
                }

                MouseArea {
                    id: loginButtonMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: !busy && usernameField.text.trim().length > 0 && passwordField.text.length > 0
                    onClicked: {
                        submitLogin()
                    }
                }

                Keys.onReturn: {
                    submitLogin()
                }
            }
        }

        // --- Status prompt ---
        Item {
            anchors.top: panel.bottom
            anchors.topMargin: 16
            width: parent.width
            height: root.statusMessage ? 44 : 0
            visible: root.statusMessage.length > 0

            Rectangle {
                id: status
                width: parent.width
                height: 44
                radius: 8
                color: "transparent"

                Rectangle {
                    id: statusBg
                    anchors.fill: parent
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0.00; color: "#334155" }
                        GradientStop { position: 1.00; color: "#1e293b" }
                    }
                    border.color: "#64748b"
                    border.width: 1
                }

                Text {
                    id: statusLabel
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 18
                    text: root.statusMessage
                    color: textConstants.failureText
                    font.family: "Noto Sans"
                    font.pixelSize: Math.min(root.width * 0.03, 18)
                    elide: Text.ElideLastElement
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // Bottom controls: shutdown, reboot, suspend, hibernate.
    // ------------------------------------------------------------------
    Column {
        id: bottomControls
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Row {
            spacing: 10
            opacity: 0.92

            Button {
                id: shutdownBtn
                text: textConstants.shutdown
                font.pixelSize: Math.min(root.width * 0.028, 16)
                color: "#f4f7ff"
                activeColor: "#b91c1c"
                pressedColor: "#7f1d1d"
                enabled: sddm.canPowerOff
                height: 40

                Text {
                    anchors.centerIn: parent
                    text: shutdownBtn.text
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        shutdownBtn.clicked()
                        sddm.powerOff()
                    }
                }
            }

            Button {
                id: rebootBtn
                text: textConstants.reboot
                font.pixelSize: Math.min(root.width * 0.028, 16)
                color: "#f4f7ff"
                activeColor: "#b91c1c"
                pressedColor: "#7f1d1d"
                enabled: sddm.canReboot
                height: 40

                Text {
                    anchors.centerIn: parent
                    text: rebootBtn.text
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        rebootBtn.clicked()
                        sddm.reboot()
                    }
                }
            }
        }

        Row {
            spacing: 10
            opacity: 0.92

            Button {
                id: suspendBtn
                text: textConstants.suspend
                font.pixelSize: Math.min(root.width * 0.028, 16)
                color: "#f4f7ff"
                activeColor: "#1d4ed8"
                pressedColor: "#1e3a8a"
                enabled: sddm.canSuspend
                height: 40

                Text {
                    anchors.centerIn: parent
                    text: suspendBtn.text
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        suspendBtn.clicked()
                        sddm.suspend()
                    }
                }
            }

            Button {
                id: hibernateBtn
                text: textConstants.hibernate
                font.pixelSize: Math.min(root.width * 0.028, 16)
                color: "#f4f7ff"
                activeColor: "#65a30d"
                pressedColor: "#4d7c0f"
                enabled: sddm.canHibernate
                height: 40

                Text {
                    anchors.centerIn: parent
                    text: hibernateBtn.text
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        hibernateBtn.clicked()
                        sddm.hibernate()
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // Busy indicator shown during authentication.
    // ------------------------------------------------------------------
    Rectangle {
        id: busy
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: loginButton.bottom
        anchors.topMargin: 18
        width: Math.min(root.width * 0.12, 56)
        height: width
        radius: width / 2
        color: "#6366f1"
        opacity: 0.85
    }

    // ------------------------------------------------------------------
    // Login submission. Called by the login button, the Enter key, and
    // keyboard entry. Uses the SDDM sddm proxy.
    // ------------------------------------------------------------------
    function submitLogin() {
        if (busy.visible) return

        var user = usernameField.text.trim()
        var pass = passwordField.text
        var sess = sessionField.index

        if (user.length === 0) {
            root.statusMessage = "Please enter a username."
            busy.visible = false
            return
        }

        if (pass.length === 0) {
            root.statusMessage = textConstants.emptyPassword
            busy.visible = false
            return
        }

        if (sess < 0 || sess >= sessionModel.count) {
            root.statusMessage = "No session selected."
            busy.visible = false
            return
        }

        busy.visible = true
        root.statusMessage = ""
        sddm.login(user, pass, sess)
    }

    // Initialise the session field once sessionModel is populated.
    Component.onCompleted: {
        if (sessionModel.count > 0) {
            sessionField.index = sessionModel.lastIndex
        }
    }
}
