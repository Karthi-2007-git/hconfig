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
                var b = BrightnessService.brightness;
                if (b >= 0.7) return "\U000f00df";  // 󰃟 nf-md-brightness_7
                if (b >= 0.4) return "\U000f00de";  // 󰃞 nf-md-brightness_6
                return "\U000f00db";                  // 󰃛 nf-md-brightness_3
            }
            color: Theme.peach
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeIcon
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: Math.round(BrightnessService.brightness * 100) + "%"
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onWheel: function(event) {
            if (event.angleDelta.y > 0) {
                BrightnessService.increase();
            } else {
                BrightnessService.decrease();
            }
        }
    }
}
