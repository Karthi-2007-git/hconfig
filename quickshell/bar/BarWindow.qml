import Quickshell
import Quickshell.Wayland
import QtQuick
import ".."

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    exclusiveZone: Theme.barHeight + Theme.barMargin * 2
    implicitHeight: Theme.barHeight + Theme.barMargin * 2
    color: "transparent"

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top

    Bar {
        id: bar
        anchors.fill: parent
        anchors.margins: Theme.barMargin
    }
}
