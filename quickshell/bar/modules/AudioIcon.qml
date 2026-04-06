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
                if (AudioService.muted) return "\U000f0581";      // 󰖁 nf-md-volume_off
                if (AudioService.volume < 0.3) return "\U000f057f"; // 󰕿 nf-md-volume_low
                if (AudioService.volume < 0.7) return "\U000f0580"; // 󰖀 nf-md-volume_medium
                return "\U000f057e";                                 // 󰕾 nf-md-volume_high
            }
            color: AudioService.muted ? Theme.surface2 : Theme.mauve
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeIcon
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: Math.round(AudioService.volume * 100) + "%"
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        hoverEnabled: true

        onClicked: function(mouse) {
            if (mouse.button === Qt.MiddleButton) {
                AudioService.toggleMute();
            } else {
                var mapped = root.mapToItem(null, root.width / 2, 0);
                PopoutState.toggle("audio", mapped.x);
            }
        }

        onWheel: function(event) {
            if (event.angleDelta.y > 0) {
                AudioService.incrementVolume();
            } else {
                AudioService.decrementVolume();
            }
        }
    }
}
