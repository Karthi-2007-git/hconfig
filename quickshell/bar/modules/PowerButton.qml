import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

Item {
    id: root
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    property bool menuOpen: false

    Text {
        id: icon
        text: "\U000f0425"  // 󰐥 nf-md-power
        color: Theme.red
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeIcon
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            anchors.fill: parent
            onClicked: root.menuOpen = !root.menuOpen
        }
    }

    // Inline power menu dropdown
    Rectangle {
        id: menu
        visible: root.menuOpen
        anchors.top: icon.bottom
        anchors.topMargin: Theme.barMargin + Theme.padding
        anchors.right: parent.right
        width: 180
        height: menuCol.implicitHeight + Theme.paddingLarge * 2
        radius: Theme.popoutRadius
        color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.95)
        border.width: 1
        border.color: Qt.rgba(Theme.surface1.r, Theme.surface1.g, Theme.surface1.b, 0.6)
        z: 100

        ColumnLayout {
            id: menuCol
            anchors.fill: parent
            anchors.margins: Theme.paddingLarge
            spacing: 4

            Repeater {
                model: [
                    { label: "Lock", icon: "\uf023", cmd: "loginctl lock-session" },
                    { label: "Suspend", icon: "\U000f04b2", cmd: "systemctl suspend" },
                    { label: "Log Out", icon: "\U000f0343", cmd: "hyprctl dispatch exit" },
                    { label: "Reboot", icon: "\U000f0709", cmd: "systemctl reboot" },
                    { label: "Shutdown", icon: "\U000f0425", cmd: "systemctl poweroff" }
                ]

                Rectangle {
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: ma.containsMouse ? Theme.surface0 : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.padding
                        anchors.rightMargin: Theme.padding
                        spacing: Theme.padding

                        Text {
                            text: modelData.icon
                            color: index >= 3 ? Theme.red : Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeIcon
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: modelData.label
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.menuOpen = false;
                            Quickshell.execDetached(["sh", "-c", modelData.cmd]);
                        }
                    }
                }
            }
        }
    }
}
