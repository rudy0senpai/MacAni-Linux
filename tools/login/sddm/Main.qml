import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

// MacAni visual concept for SDDM. This is a background/branding layer,
// not a complete greeter: retain your existing login controls.
Rectangle {
    anchors.fill: parent
    color: "#050817"

    Image {
        anchors.fill: parent
        source: "background.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.98
    }

    Image {
        id: macaniLogo
        source: "logo.png"
        width: Math.min(parent.width * 0.20, 260)
        height: width * (1196/1315)
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height * 0.13
        opacity: 0
        scale: 0.82

        Behavior on opacity { NumberAnimation { duration: 1000; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 1100; easing.type: Easing.OutBack } }

        Component.onCompleted: {
            opacity = 1
            scale = 1
        }
    }

    Rectangle {
        width: Math.min(parent.width * 0.42, 560)
        height: 62
        radius: 31
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: macaniLogo.bottom
        anchors.topMargin: 24
        color: "#33203c55"
        border.width: 1.5
        border.color: "#7b5cff"

        Text {
            anchors.centerIn: parent
            text: "MacAni Linux"
            font.pixelSize: Math.min(parent.width * 0.035, 44)
            font.family: "Noto Sans"
            color: "#f4f7ff"
        }

        SequentialAnimation on opacity {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 0.82; duration: 1300 }
            NumberAnimation { to: 1.0; duration: 1300 }
        }
    }
}
