import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../.."

RowLayout {
    spacing: 4

    Repeater {
        model: {
            var ws = [];
            var values = Hyprland.workspaces.values;
            for (var i = 0; i < values.length; i++) {
                var w = values[i];
                if (w.id > 0 && w.id <= 10) {
                    ws.push(w.id);
                }
            }
            ws.sort(function(a, b) { return a - b; });
            // Always show workspaces 1-5 minimum, plus any active ones
            var result = [1, 2, 3, 4, 5];
            for (var j = 0; j < ws.length; j++) {
                if (result.indexOf(ws[j]) === -1) {
                    result.push(ws[j]);
                }
            }
            result.sort(function(a, b) { return a - b; });
            return result;
        }

        Rectangle {
            required property int modelData

            width: 20
            height: 20
            radius: 6
            color: {
                var focused = Hyprland.focusedWorkspace;
                if (focused && focused.id === modelData) return Theme.blue;
                // Check if workspace has windows
                var values = Hyprland.workspaces.values;
                for (var i = 0; i < values.length; i++) {
                    if (values[i].id === modelData) return Theme.surface1;
                }
                return Theme.surface0;
            }

            Behavior on color { ColorAnimation { duration: Theme.animDuration } }

            Text {
                anchors.centerIn: parent
                text: modelData
                color: {
                    var focused = Hyprland.focusedWorkspace;
                    if (focused && focused.id === modelData) return Theme.bg;
                    return Theme.subtext;
                }
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData)
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            var n = event.name;
            if (n === "workspace" || n === "createworkspace" || n === "destroyworkspace" ||
                n === "focusedmon" || n === "moveworkspace") {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            }
        }
    }
}
