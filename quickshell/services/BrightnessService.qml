pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property real brightness: 1.0
    property real maxBrightness: 1.0

    Component.onCompleted: readBrightness()

    function readBrightness() {
        readProc.running = true;
    }

    function setBrightness(val) {
        val = Math.max(0.01, Math.min(1.0, val));
        brightness = val;
        var pct = Math.round(val * 100);
        setProc.command = ["brightnessctl", "s", pct + "%"];
        setProc.running = true;
    }

    function increase(step) {
        setBrightness(brightness + (step || 0.05));
    }

    function decrease(step) {
        setBrightness(brightness - (step || 0.05));
    }

    property var readProc: Process {
        command: ["sh", "-c", "echo $(brightnessctl g) $(brightnessctl m)"]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ");
                if (parts.length >= 2) {
                    var cur = parseInt(parts[0]);
                    var max = parseInt(parts[1]);
                    if (max > 0) {
                        root.maxBrightness = max;
                        root.brightness = cur / max;
                    }
                }
            }
        }
    }

    property var setProc: Process {
        command: ["brightnessctl", "s", "100%"]
    }

    // Poll brightness every 5 seconds to catch external changes
    property var pollTimer: Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.readBrightness()
    }
}
