pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var networks: []
    property bool connected: false
    property string ssid: ""
    property int strength: 0
    property bool wifiEnabled: true
    property bool scanning: false
    property string connectingTo: ""

    Component.onCompleted: {
        checkWifiStatus();
        Qt.callLater(getNetworks);
    }

    function getNetworks() {
        scanProc.running = true;
    }

    function rescan() {
        root.scanning = true;
        rescanProc.running = true;
    }

    function connectToNetwork(targetSsid, password) {
        root.connectingTo = targetSsid;
        if (password) {
            connectProc.command = ["nmcli", "device", "wifi", "connect", targetSsid, "password", password];
        } else {
            connectProc.command = ["nmcli", "device", "wifi", "connect", targetSsid];
        }
        connectProc.running = true;
    }

    function disconnectFromNetwork() {
        disconnectProc.running = true;
    }

    function enableWifi(on) {
        wifiToggleProc.command = ["nmcli", "radio", "wifi", on ? "on" : "off"];
        wifiToggleProc.running = true;
    }

    function checkWifiStatus() {
        wifiStatusProc.running = true;
    }

    // Scan for networks
    property var scanProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "-t", "-g", "ACTIVE,SIGNAL,SSID,SECURITY", "device", "wifi", "list"]
        stdout: SplitParser {
            onRead: function(line) {
                if (!root._scanBuffer) root._scanBuffer = [];
                var parts = line.split(":");
                if (parts.length >= 4) {
                    var ssidVal = parts[2];
                    if (!ssidVal || ssidVal === "") return;
                    // Avoid duplicates, keep strongest
                    var existing = root._scanBuffer.find(function(n) { return n.ssid === ssidVal; });
                    if (existing) {
                        if (parseInt(parts[1]) > existing.strength) {
                            existing.strength = parseInt(parts[1]);
                            existing.active = parts[0] === "yes";
                            existing.security = parts.slice(3).join(":");
                        }
                        return;
                    }
                    root._scanBuffer.push({
                        active: parts[0] === "yes",
                        strength: parseInt(parts[1]),
                        ssid: ssidVal,
                        security: parts.slice(3).join(":")
                    });
                }
            }
        }
        onRunningChanged: {
            if (!running) {
                var buf = root._scanBuffer || [];
                // Sort: active first, then by signal strength
                buf.sort(function(a, b) {
                    if (a.active && !b.active) return -1;
                    if (!a.active && b.active) return 1;
                    return b.strength - a.strength;
                });
                root.networks = buf;
                root._scanBuffer = [];

                // Update connected status
                var activeNet = buf.find(function(n) { return n.active; });
                root.connected = !!activeNet;
                root.ssid = activeNet ? activeNet.ssid : "";
                root.strength = activeNet ? activeNet.strength : 0;
                root.scanning = false;
                root.connectingTo = "";
            }
        }
    }

    // Rescan
    property var rescanProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "device", "wifi", "list", "--rescan", "yes"]
        onRunningChanged: {
            if (!running) {
                root.getNetworks();
            }
        }
    }

    // Connect
    property var connectProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "device", "wifi", "connect", "dummy"]
        onRunningChanged: {
            if (!running) {
                Qt.callLater(function() { root.getNetworks(); });
            }
        }
    }

    // Disconnect
    property var disconnectProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "device", "disconnect", "wifi"]
        onRunningChanged: {
            if (!running) {
                Qt.callLater(function() { root.getNetworks(); });
            }
        }
    }

    // Wifi toggle
    property var wifiToggleProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "radio", "wifi", "on"]
        onRunningChanged: {
            if (!running) {
                root.checkWifiStatus();
                Qt.callLater(function() { root.getNetworks(); });
            }
        }
    }

    // Wifi status
    property var wifiStatusProc: Process {
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "radio", "wifi"]
        stdout: SplitParser {
            onRead: function(line) {
                root.wifiEnabled = line.trim() === "enabled";
            }
        }
    }

    // Monitor for network changes
    property var monitorProc: Process {
        running: true
        environment: ({ LANG: "C.UTF-8", LC_ALL: "C.UTF-8" })
        command: ["nmcli", "monitor"]
        stdout: SplitParser {
            onRead: function(line) {
                root.getNetworks();
            }
        }
    }

    property var _scanBuffer: []
}
