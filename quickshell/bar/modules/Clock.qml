import QtQuick
import QtQuick.Layouts
import "../.."

RowLayout {
    spacing: Theme.spacing

    property string _time: ""
    property string _date: ""

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            _time = Qt.formatDateTime(now, "hh:mm");
            _date = Qt.formatDateTime(now, "ddd, MMM d");
        }
    }

    Text {
        text: "\uf073"
        color: Theme.teal
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeIcon
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
        spacing: -2
        Layout.alignment: Qt.AlignVCenter

        Text {
            text: _time
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.bold: true
        }

        Text {
            text: _date
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }
    }
}
