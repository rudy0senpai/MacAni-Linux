import QtQuick
import org.kde.kirigami as Kirigami

Kirigami.ShadowedRectangle {
    property var theme: AnimeConstants

    shadow.size: 12
    shadow.color: Qt.rgba(0.0, 0.0, 0.0, 0.45)

    color: theme.popupBackgroundColor
    radius: theme.popupRadius
    border {
        width: 1
        color: theme.popupBorderColor
    }
}
