import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import ".."

PanelWindow {
    id: popoutWindow

    property string activePopout: PopoutState.activePopout
    property real popoutX: PopoutState.popoutX

    visible: PopoutState.activePopout !== ""
    color: "transparent"

    anchors {
        top: true
        right: true
    }

    // Size to fit content
    implicitWidth: contentLoader.item ? contentLoader.item.implicitWidth + Theme.paddingLarge * 2 : 300
    implicitHeight: contentLoader.item ? contentLoader.item.implicitHeight + Theme.paddingLarge * 2 : 200

    WlrLayershell.namespace: "quickshell-popout"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: PopoutState.activePopout !== "" ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    exclusiveZone: 0
    focusable: true

    margins {
        top: Theme.barHeight + Theme.barMargin * 2 + 4
        right: 8
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: PopoutState.activePopout !== ""
        windows: [popoutWindow]
        onCleared: PopoutState.close()
    }

    // Main container with frosted glass effect
    Rectangle {
        id: container
        anchors.fill: parent
        radius: Theme.popoutRadius
        color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.92)
        border.width: 1
        border.color: Qt.rgba(Theme.surface1.r, Theme.surface1.g, Theme.surface1.b, 0.6)
        clip: true

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.margins: Theme.paddingLarge

            sourceComponent: {
                if (PopoutState.activePopout === "audio") return audioComp;
                if (PopoutState.activePopout === "network") return networkComp;
                return null;
            }
        }
    }

    // Handle Escape key
    Item {
        focus: PopoutState.activePopout !== ""
        Keys.onEscapePressed: PopoutState.close()
    }

    Component {
        id: audioComp
        AudioPopout {}
    }

    Component {
        id: networkComp
        NetworkPopout {}
    }
}
