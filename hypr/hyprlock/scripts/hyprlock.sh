#!/usr/bin/env bash

# Pause media and mute before locking.
playerctl pause 2>/dev/null || true
pactl set-sink-mute @DEFAULT_SINK@ 1 2>/dev/null || true

if pgrep -x hyprlock >/dev/null; then
	exit 0
fi

exec hyprlock