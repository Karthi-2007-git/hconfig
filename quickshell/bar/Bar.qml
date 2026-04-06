import QtQuick
import QtQuick.Layouts
import "modules"
import ".."

Rectangle {
    id: root

    radius: Theme.barRadius
    color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, Theme.bgAlpha)
    border.width: 1
    border.color: Qt.rgba(Theme.surface1.r, Theme.surface1.g, Theme.surface1.b, 0.5)

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.paddingLarge
        spacing: Theme.spacingLarge

        // Left section
        Workspaces {
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            width: 1
            height: 18
            color: Theme.surface1
            Layout.alignment: Qt.AlignVCenter
        }

        ActiveWindow {
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 300
        }

        // Center spacer
        Item { Layout.fillWidth: true }

        // Right section
        SysTray {
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            width: 1
            height: 18
            color: Theme.surface1
            Layout.alignment: Qt.AlignVCenter
        }

        BrightnessSlider {
            Layout.alignment: Qt.AlignVCenter
        }

        AudioIcon {
            Layout.alignment: Qt.AlignVCenter
        }

        NetworkIcon {
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            width: 1
            height: 18
            color: Theme.surface1
            Layout.alignment: Qt.AlignVCenter
        }

        BatteryIcon {
            Layout.alignment: Qt.AlignVCenter
        }

        Clock {
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            width: 1
            height: 18
            color: Theme.surface1
            Layout.alignment: Qt.AlignVCenter
        }

        PowerButton {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
