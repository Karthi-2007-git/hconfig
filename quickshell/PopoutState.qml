pragma Singleton

import QtQuick

QtObject {
    property string activePopout: ""
    property real popoutX: 0

    function toggle(name, x) {
        if (activePopout === name) {
            activePopout = "";
        } else {
            popoutX = x;
            activePopout = name;
        }
    }

    function close() {
        activePopout = "";
    }
}
