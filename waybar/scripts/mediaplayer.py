#!/usr/bin/env python3
# ~/.config/waybar/scripts/mediaplayer.py
# Enhanced media module — title, artist, progress bar, player icon
# Requires: playerctl

import json
import subprocess
import sys


PLAYER_ICONS = {
    "spotify":   "󰓇",
    "firefox":   "󰈹",
    "chromium":  "󰊯",
    "mpv":       "󰎁",
    "vlc":       "󰕼",
    "rhythmbox": "󰓃",
    "cmus":      "󰝚",
    "default":   "󰎇",
}

BAR_LENGTH = 10


def build_progress_bar(position: float, length: float) -> str:
    if length <= 0:
        return ""
    percent = min(position / length, 1.0)
    filled = round(percent * BAR_LENGTH)
    empty = BAR_LENGTH - filled
    bar = "█" * filled + "░" * empty
    elapsed = fmt_time(position)
    total = fmt_time(length)
    return f"{elapsed} {bar} {total}"


def fmt_time(seconds: float) -> str:
    seconds = int(seconds)
    m, s = divmod(seconds, 60)
    return f"{m}:{s:02d}"


def run(cmd):
    try:
        return subprocess.check_output(
            cmd, stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        return ""


def get_player_status():
    players = run(["playerctl", "-l"])
    if not players:
        return None

    player = players.split("\n")[0]
    status = run(["playerctl", "-p", player, "status"])
    if not status or status == "Stopped":
        return None

    title  = run(["playerctl", "-p", player, "metadata", "title"])
    artist = run(["playerctl", "-p", player, "metadata", "artist"])
    pos    = run(["playerctl", "-p", player, "position"])
    length = run(["playerctl", "-p", player, "metadata", "mpris:length"])

    player_key = player.lower().split(".")[0]
    icon = PLAYER_ICONS.get(player_key, PLAYER_ICONS["default"])

    display = f"{artist} — {title}" if artist else title
    if len(display) > 35:
        display = display[:33] + "…"

    progress = ""
    percentage = 0
    if pos and length:
        try:
            pos_sec = float(pos)
            len_sec = float(length) / 1_000_000
            progress = build_progress_bar(pos_sec, len_sec)
            percentage = int(min(pos_sec / len_sec * 100, 100))
        except ValueError:
            pass

    is_playing = status == "Playing"
    play_icon  = "󰏤" if is_playing else "󰐊"
    text       = f"{icon}  {display}  {play_icon}"
    tooltip    = f"{icon}  <b>{title}</b>\n󰎈  {artist}\n\n{progress}" if progress else f"{icon}  <b>{title}</b>\n󰎈  {artist}"

    return {
        "text":       text,
        "tooltip":    tooltip,
        "class":      player_key if is_playing else "paused",
        "alt":        player_key,
        "percentage": percentage,
    }


def main():
    result = get_player_status()
    if result:
        print(json.dumps(result), flush=True)
    else:
        print(json.dumps({
            "text":    "󰎇  Nothing playing",
            "tooltip": "No active media player",
            "class":   "inactive",
            "alt":     "default",
        }), flush=True)


if __name__ == "__main__":
    main()
