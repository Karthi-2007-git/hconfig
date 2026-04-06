pragma Singleton

import QtQuick

QtObject {
    // Catppuccin Mocha palette
    readonly property color bg: "#1e1e2e"
    readonly property real bgAlpha: 0.82
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color text: "#cdd6f4"
    readonly property color subtext: "#a6adc8"
    readonly property color blue: "#89b4fa"
    readonly property color mauve: "#cba6f7"
    readonly property color green: "#a6e3a1"
    readonly property color red: "#f38ba8"
    readonly property color peach: "#fab387"
    readonly property color teal: "#94e2d5"
    readonly property color yellow: "#f9e2af"
    readonly property color lavender: "#b4befe"

    // Font
    readonly property string fontFamily: "MesloLGS Nerd Font"
    readonly property int fontSizeSmall: 10
    readonly property int fontSizeNormal: 12
    readonly property int fontSizeLarge: 14
    readonly property int fontSizeIcon: 16

    // Dimensions
    readonly property int barHeight: 36
    readonly property int barMargin: 4
    readonly property int barRadius: 12
    readonly property int popoutRadius: 14
    readonly property int padding: 8
    readonly property int paddingLarge: 12
    readonly property int spacing: 6
    readonly property int spacingLarge: 10

    // Animation
    readonly property int animDuration: 200
    readonly property int animDurationSlow: 350
}
