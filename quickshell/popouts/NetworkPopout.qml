import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services"
import ".."

Item {
    id: root

    implicitWidth: 300
    implicitHeight: layout.implicitHeight

    property bool showPassword: false
    property string passwordSsid: ""

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: Theme.spacingLarge

        // Header with WiFi toggle
        RowLayout {
            spacing: Theme.spacing

            Text {
                text: "\U000f0928 Wi-Fi"
                color: Theme.teal
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                Layout.fillWidth: true
            }

            // Wifi toggle
            Rectangle {
                width: 44
                height: 22
                radius: 11
                color: NetworkService.wifiEnabled ? Theme.teal : Theme.surface1

                Behavior on color { ColorAnimation { duration: Theme.animDuration } }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    x: NetworkService.wifiEnabled ? parent.width - width - 2 : 2
                    y: 2
                    color: Theme.text

                    Behavior on x { NumberAnimation { duration: Theme.animDuration; easing.type: Easing.OutCubic } }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: NetworkService.enableWifi(!NetworkService.wifiEnabled)
                }
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.surface1
        }

        // Connected network info
        Rectangle {
            visible: NetworkService.connected
            Layout.fillWidth: true
            height: connectedRow.implicitHeight + Theme.padding * 2
            radius: 8
            color: Qt.rgba(Theme.teal.r, Theme.teal.g, Theme.teal.b, 0.1)
            border.width: 1
            border.color: Qt.rgba(Theme.teal.r, Theme.teal.g, Theme.teal.b, 0.3)

            RowLayout {
                id: connectedRow
                anchors.fill: parent
                anchors.margins: Theme.padding
                spacing: Theme.spacing

                Text {
                    text: "\U000f0928"
                    color: Theme.teal
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeIcon
                }

                ColumnLayout {
                    spacing: -2
                    Layout.fillWidth: true

                    Text {
                        text: NetworkService.ssid
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                    }
                    Text {
                        text: "Connected \u2022 " + NetworkService.strength + "%"
                        color: Theme.subtext
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                // Disconnect button
                Rectangle {
                    width: 70
                    height: 26
                    radius: 6
                    color: dcMa.containsMouse ? Qt.rgba(Theme.red.r, Theme.red.g, Theme.red.b, 0.2) : "transparent"
                    border.width: 1
                    border.color: Theme.red

                    Text {
                        anchors.centerIn: parent
                        text: "Disconnect"
                        color: Theme.red
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    MouseArea {
                        id: dcMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: NetworkService.disconnectFromNetwork()
                    }
                }
            }
        }

        // Password entry
        Rectangle {
            id: passwordEntry
            visible: root.showPassword
            Layout.fillWidth: true
            height: passwordCol.implicitHeight + Theme.padding * 2
            radius: 8
            color: Theme.surface0

            ColumnLayout {
                id: passwordCol
                anchors.fill: parent
                anchors.margins: Theme.padding
                spacing: Theme.spacing

                Text {
                    text: "Password for " + root.passwordSsid
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }

                RowLayout {
                    spacing: Theme.spacing

                    Rectangle {
                        Layout.fillWidth: true
                        height: 30
                        radius: 6
                        color: Theme.surface1

                        TextInput {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.margins: 6
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            echoMode: TextInput.Password
                            clip: true

                            Keys.onReturnPressed: connectWithPassword()
                        }
                    }

                    Rectangle {
                        width: 60
                        height: 30
                        radius: 6
                        color: connectBtnMa.containsMouse ? Qt.darker(Theme.teal, 1.2) : Theme.teal

                        Text {
                            anchors.centerIn: parent
                            text: "Connect"
                            color: Theme.bg
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                            font.bold: true
                        }

                        MouseArea {
                            id: connectBtnMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: connectWithPassword()
                        }
                    }

                    Rectangle {
                        width: 30
                        height: 30
                        radius: 6
                        color: cancelMa.containsMouse ? Theme.surface1 : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "\uf00d"
                            color: Theme.subtext
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: cancelMa
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.showPassword = false;
                                root.passwordSsid = "";
                                passwordInput.text = "";
                            }
                        }
                    }
                }
            }
        }

        // Network list header
        RowLayout {
            visible: NetworkService.wifiEnabled
            spacing: Theme.spacing

            Text {
                text: "Available Networks"
                color: Theme.subtext
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                Layout.fillWidth: true
            }

            // Rescan button
            Rectangle {
                width: 24
                height: 24
                radius: 6
                color: rescanMa.containsMouse ? Theme.surface0 : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "\U000f0450"  // 󰑐 nf-md-refresh
                    color: NetworkService.scanning ? Theme.teal : Theme.subtext
                    font.family: Theme.fontFamily
                    font.pixelSize: 14

                    RotationAnimation on rotation {
                        running: NetworkService.scanning
                        from: 0
                        to: 360
                        duration: 1000
                        loops: Animation.Infinite
                    }
                }

                MouseArea {
                    id: rescanMa
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: NetworkService.rescan()
                }
            }
        }

        // Network list
        ColumnLayout {
            visible: NetworkService.wifiEnabled
            spacing: 2

            Repeater {
                model: {
                    // Show up to 10 networks, exclude active one (shown separately above)
                    var nets = NetworkService.networks;
                    var result = [];
                    for (var i = 0; i < nets.length && result.length < 10; i++) {
                        if (!nets[i].active) {
                            result.push(nets[i]);
                        }
                    }
                    return result;
                }

                Rectangle {
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: netMa.containsMouse ? Theme.surface0 : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.padding
                        anchors.rightMargin: Theme.padding
                        spacing: Theme.spacing

                        // Signal icon
                        Text {
                            text: {
                                var s = modelData.strength;
                                if (s >= 80) return "\U000f0928";
                                if (s >= 60) return "\U000f0925";
                                if (s >= 40) return "\U000f0922";
                                if (s >= 20) return "\U000f091f";
                                return "\U000f092b";
                            }
                            color: Theme.subtext
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                        }

                        // Lock icon for secured networks
                        Text {
                            visible: modelData.security && modelData.security.length > 0
                            text: "\uf023"
                            color: Theme.overlay0
                            font.family: Theme.fontFamily
                            font.pixelSize: 10
                        }

                        // SSID
                        Text {
                            text: modelData.ssid
                            color: Theme.text
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeNormal
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        // Signal strength %
                        Text {
                            text: modelData.strength + "%"
                            color: Theme.overlay0
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSmall
                        }

                        // Connecting indicator
                        Text {
                            visible: NetworkService.connectingTo === modelData.ssid
                            text: "\U000f0450"
                            color: Theme.teal
                            font.family: Theme.fontFamily
                            font.pixelSize: 12

                            RotationAnimation on rotation {
                                running: NetworkService.connectingTo === modelData.ssid
                                from: 0
                                to: 360
                                duration: 1000
                                loops: Animation.Infinite
                            }
                        }
                    }

                    MouseArea {
                        id: netMa
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (modelData.security && modelData.security.length > 0) {
                                // Secured network — try without password first (saved connections), then show password prompt
                                root.passwordSsid = modelData.ssid;
                                root.showPassword = true;
                                passwordInput.forceActiveFocus();
                            } else {
                                NetworkService.connectToNetwork(modelData.ssid);
                            }
                        }
                    }
                }
            }
        }

        // Empty state
        Text {
            visible: NetworkService.wifiEnabled && NetworkService.networks.length === 0
            text: "Scanning for networks..."
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            Layout.alignment: Qt.AlignHCenter
        }

        // WiFi disabled state
        Text {
            visible: !NetworkService.wifiEnabled
            text: "Wi-Fi is disabled"
            color: Theme.subtext
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function connectWithPassword() {
        var pw = passwordInput.text;
        if (pw.length > 0 && root.passwordSsid.length > 0) {
            NetworkService.connectToNetwork(root.passwordSsid, pw);
            root.showPassword = false;
            root.passwordSsid = "";
            passwordInput.text = "";
        }
    }
}
