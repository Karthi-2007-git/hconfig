import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import ".."

Item {
    id: root

    implicitWidth: 280
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Theme.spacingLarge

        // Header
        Text {
            text: "\U000f057e Audio"
            color: Theme.mauve
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            font.bold: true
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.surface1
        }

        // Volume control
        ColumnLayout {
            spacing: Theme.spacing

            Text {
                text: "Volume  " + Math.round(AudioService.volume * 100) + "%"
                color: Theme.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeNormal
            }

            RowLayout {
                spacing: Theme.spacing
                Layout.fillWidth: true

                // Mute button
                Rectangle {
                    width: 28
                    height: 28
                    radius: 8
                    color: AudioService.muted ? Theme.surface1 : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: AudioService.muted ? "\U000f0581" : "\U000f057e"
                        color: AudioService.muted ? Theme.red : Theme.mauve
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: AudioService.toggleMute()
                    }
                }

                // Volume slider
                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 1.0
                    value: AudioService.volume
                    stepSize: 0.01

                    onMoved: AudioService.setVolume(value)

                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: volumeSlider.availableWidth
                        height: 4
                        radius: 2
                        color: Theme.surface1

                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            radius: 2
                            color: Theme.mauve
                        }
                    }

                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: 14
                        height: 14
                        radius: 7
                        color: volumeSlider.pressed ? Theme.lavender : Theme.mauve
                        border.width: 2
                        border.color: Theme.bg
                    }
                }
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.surface1
        }

        // Output devices
        ColumnLayout {
            spacing: Theme.spacing

            Text {
                text: "Output Device"
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Repeater {
                model: AudioService.sinks

                Rectangle {
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: {
                        var isActive = AudioService.sink && modelData && AudioService.sink.name === modelData.name;
                        return isActive ? Qt.rgba(Theme.mauve.r, Theme.mauve.g, Theme.mauve.b, 0.15) :
                               sinkMa.containsMouse ? Theme.surface0 : "transparent";
                    }

                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.padding
                        anchors.rightMargin: Theme.padding
                        spacing: Theme.spacing

                        Text {
                            text: "\U000f04c3"  // 󰓃 nf-md-speaker
                            color: {
                                var isActive = AudioService.sink && modelData && AudioService.sink.name === modelData.name;
                                return isActive ? Theme.mauve : Theme.subtext;
                            }
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: modelData ? (modelData.description || modelData.name || "Unknown") : "Unknown"
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                        }

                        // Active indicator dot
                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: Theme.mauve
                            visible: AudioService.sink && modelData && AudioService.sink.name === modelData.name
                        }
                    }

                    MouseArea {
                        id: sinkMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: AudioService.setSink(modelData)
                    }
                }
            }
        }

        // Input devices
        ColumnLayout {
            spacing: Theme.spacing

            Text {
                text: "Input Device"
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Repeater {
                model: AudioService.sources

                Rectangle {
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    height: 32
                    radius: 8
                    color: {
                        var isActive = AudioService.source && modelData && AudioService.source.name === modelData.name;
                        return isActive ? Qt.rgba(Theme.teal.r, Theme.teal.g, Theme.teal.b, 0.15) :
                               srcMa.containsMouse ? Theme.surface0 : "transparent";
                    }

                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.padding
                        anchors.rightMargin: Theme.padding
                        spacing: Theme.spacing

                        Text {
                            text: "\U000f036c"  // 󰍬 nf-md-microphone
                            color: {
                                var isActive = AudioService.source && modelData && AudioService.source.name === modelData.name;
                                return isActive ? Theme.teal : Theme.subtext;
                            }
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: modelData ? (modelData.description || modelData.name || "Unknown") : "Unknown"
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                        }

                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: Theme.teal
                            visible: AudioService.source && modelData && AudioService.source.name === modelData.name
                        }
                    }

                    MouseArea {
                        id: srcMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: AudioService.setSource(modelData)
                    }
                }
            }
        }
    }
}
