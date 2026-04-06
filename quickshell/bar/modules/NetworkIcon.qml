import QtQuick
import QtQuick.Layouts
import "../../services"
import "../.."

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: {
                if (!NetworkService.wifiEnabled) return "\U000f05aa"; // 󰖪 nf-md-wifi_off
                if (!NetworkService.connected) return "\U000f092d";   // 󰤭 nf-md-wifi_strength_off
                var s = NetworkService.strength;
                if (s >= 80) return "\U000f0928";                     // 󰤨 nf-md-wifi_strength_4
                if (s >= 60) return "\U000f0925";                     // 󰤥 nf-md-wifi_strength_3
                if (s >= 40) return "\U000f0922";                     // 󰤢 nf-md-wifi_strength_2
                if (s >= 20) return "\U000f091f";                     // 󰤟 nf-md-wifi_strength_1
                return "\U000f092b";                                   // 󰤫 nf-md-wifi_strength_alert
            }
            color: NetworkService.connected ? Theme.teal : Theme.surface2
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeIcon
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var mapped = root.mapToItem(null, root.width / 2, 0);
            PopoutState.toggle("network", mapped.x);
        }
    }
}
