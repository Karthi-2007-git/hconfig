import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import "../.."

RowLayout {
    spacing: 4

    Repeater {
        model: SystemTray.items

        Item {
            required property var modelData
            width: 20
            height: 20
            Layout.alignment: Qt.AlignVCenter

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: modelData.icon ?? ""
                sourceSize: Qt.size(16, 16)
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: function(mouse) {
                    if (mouse.button === Qt.RightButton) {
                        modelData.secondaryActivate();
                    } else {
                        modelData.activate();
                    }
                }
            }
        }
    }
}
