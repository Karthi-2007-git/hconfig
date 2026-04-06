pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

QtObject {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

    readonly property real sourceVolume: source && source.audio ? source.audio.volume : 0
    readonly property bool sourceMuted: source && source.audio ? source.audio.muted : false

    readonly property var sinks: {
        var result = [];
        var nodes = Pipewire.nodes.values;
        for (var i = 0; i < nodes.length; i++) {
            var n = nodes[i];
            if (!n.isStream && n.isSink) {
                result.push(n);
            }
        }
        return result;
    }

    readonly property var sources: {
        var result = [];
        var nodes = Pipewire.nodes.values;
        for (var i = 0; i < nodes.length; i++) {
            var n = nodes[i];
            if (!n.isStream && n.audio && !n.isSink) {
                result.push(n);
            }
        }
        return result;
    }

    function setVolume(val) {
        if (sink && sink.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1.5, val));
        }
    }

    function incrementVolume(step) {
        setVolume(volume + (step || 0.05));
    }

    function decrementVolume(step) {
        setVolume(volume - (step || 0.05));
    }

    function toggleMute() {
        if (sink && sink.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    function setSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    function setSource(node) {
        Pipewire.preferredDefaultAudioSource = node;
    }

    property var _tracker: PwObjectTracker {
        objects: {
            var all = [];
            var s = root.sinks;
            var sr = root.sources;
            for (var i = 0; i < s.length; i++) all.push(s[i]);
            for (var j = 0; j < sr.length; j++) all.push(sr[j]);
            if (root.sink) all.push(root.sink);
            if (root.source) all.push(root.source);
            return all;
        }
    }
}
