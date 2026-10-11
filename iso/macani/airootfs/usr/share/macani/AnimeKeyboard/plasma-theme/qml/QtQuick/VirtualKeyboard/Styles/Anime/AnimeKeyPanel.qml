import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Styles

import org.kde.plasma.keyboard
import org.kde.kirigami as Kirigami

KeyPanel {
    id: root

    default property alias contentItem: visualContainer.contentItem
    property alias background: visualContainer.background

    property real padding: AnimeConstants.keyBackgroundMargin
    property real radius: AnimeConstants.buttonRadius

    property color color: {
        if (control && control.pressed) {
            return AnimeConstants.normalKeyPressedBackgroundColor;
        } else if (control && control.highlighted) {
            return AnimeConstants.highlightedKeyBackgroundColor;
        }
        return AnimeConstants.normalKeyBackgroundColor;
    }

    soundEffect: PlasmaKeyboardSettings.soundEnabled ? Qt.resolvedUrl('qrc:///sounds/keyboard_tick2_quiet.wav') : ''

    QQC2.Control {
        id: visualContainer
        anchors.fill: parent
        anchors.margins: root.padding

        background: Kirigami.ShadowedRectangle {
            color: root.color
            radius: root.radius
            border.width: 1
            border.color: control && control.pressed ? "#ff9bd1" : "#68467d"

            shadow.color: Qt.rgba(0.0, 0.0, 0.0, 0.38)
            shadow.size: 5
            shadow.yOffset: 2
        }
    }

    Connections {
        target: root.control
        function onPressedChanged() {
            if (root.control.pressed && PlasmaKeyboardSettings.vibrationEnabled) {
                Vibration.vibrate(PlasmaKeyboardSettings.vibrationMs);
            }
        }
    }
}
