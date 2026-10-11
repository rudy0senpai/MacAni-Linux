import QtQuick
import org.kde.kirigami as Kirigami

pragma Singleton

QtObject {
    property real scaleHint: 1.0

    readonly property string fontFamily: Kirigami.Theme.defaultFont.family
    readonly property real keyBackgroundMargin: Math.round(7 * scaleHint)
    readonly property real keyContentMargin: Math.round(34 * scaleHint)
    readonly property real keyIconScale: scaleHint * 0.78

    // Anime-inspired night palette: plum, sakura pink, electric violet and cyan.
    readonly property color primaryColor: "#120d1c"
    readonly property color primaryLightColor: "#2a1d3c"
    readonly property color primaryDarkColor: "#0b0812"
    readonly property color textOnPrimaryColor: "#fff7ff"

    readonly property color secondaryColor: "#241431"
    readonly property color secondaryLightColor: "#3a214e"
    readonly property color secondaryDarkColor: "#180d22"
    readonly property color textOnSecondaryColor: "#fff7ff"

    readonly property color keyboardBackgroundColor: "#0c0814"
    readonly property color normalKeyBackgroundColor: "#251a36"
    readonly property color normalKeyPressedBackgroundColor: "#a64d9f"
    readonly property color highlightedKeyBackgroundColor: "#55306f"
    readonly property color capsLockKeyAccentColor: "#ff6fb5"
    readonly property color modeKeyAccentColor: "#7ee7ff"
    readonly property color keyTextColor: "#fff7ff"
    readonly property color keySmallTextColor: "#f5c9e5"

    readonly property color popupBackgroundColor: "#171020"
    readonly property color popupBorderColor: "#d866b2"
    readonly property color popupTextColor: "#fff7ff"
    readonly property color popupTextSelectedColor: "#ffffff"
    readonly property color popupHighlightBorderColor: "#7ee7ff"
    readonly property color popupHighlightColor: Qt.rgba(0.49, 0.91, 1.0, 0.30)

    readonly property color selectionListTextColor: "#fff7ff"
    readonly property color selectionListSeparatorColor: "#4b2e60"
    readonly property color selectionListBackgroundColor: "#120d1c"
    readonly property color navigationHighlightColor: Qt.rgba(1.0, 0.35, 0.70, 0.28)
    readonly property color navigationHighlightBorderColor: "#ff6fb5"

    readonly property real buttonRadius: Math.round(10 * scaleHint)
    readonly property real popupRadius: Math.round(12 * scaleHint)
}
