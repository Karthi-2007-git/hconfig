import QtQuick
import Quickshell.Hyprland
import "../.."

Item {
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    property string windowTitle: {
        var tl = Hyprland.activeToplevel;
        if (tl && tl.title) {
            var t = tl.title;
            return t.length > 45 ? t.substring(0, 42) + "..." : t;
        }
        return "Desktop";
    }

    Text {
        id: label
        text: windowTitle
        color: Theme.subtext
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeNormal
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            var n = event.name;
            if (n === "activewindow" || n === "openwindow" || n === "closewindow" ||
                n === "movewindow" || n === "fullscreen") {
                Hyprland.refreshToplevels();
            }
        }
    }
}
