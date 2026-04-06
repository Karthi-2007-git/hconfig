import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../.."

RowLayout {
    spacing: 4
    Layout.alignment: Qt.AlignVCenter

    readonly property var device: UPower.displayDevice
    readonly property real pct: device ? device.percentage : -1
    readonly property bool charging: device ? (device.state === UPowerDeviceState.Charging || device.state === UPowerDeviceState.FullyCharged) : false

    Text {
        text: {
            if (charging) return "\U000f0084";  // 󰂄 nf-md-battery_charging
            if (pct >= 90) return "\U000f0079";  // 󰁹 nf-md-battery
            if (pct >= 70) return "\U000f0082";  // 󰂂 nf-md-battery_80
            if (pct >= 50) return "\U000f0080";  // 󰂀 nf-md-battery_60
            if (pct >= 30) return "\U000f007e";  // 󰁾 nf-md-battery_40
            if (pct >= 10) return "\U000f007a";  // 󰁺 nf-md-battery_10 (low)
            return "\U000f008e";                  // 󰂎 nf-md-battery_alert
        }
        color: {
            if (charging) return Theme.green;
            if (pct >= 50) return Theme.text;
            if (pct >= 20) return Theme.peach;
            return Theme.red;
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeIcon
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: pct >= 0 ? Math.round(pct) + "%" : "--"
        color: Theme.subtext
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeSmall
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignVCenter
    }
}
