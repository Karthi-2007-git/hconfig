#!/bin/bash
# ~/.config/waybar/scripts/power-menu.sh
# Simple power menu using wofi

OPTIONS="  Lock\n  Suspend\n󰜺  Reboot\n  Shutdown"

CHOSEN=$(echo -e "$OPTIONS" | wofi \
  --dmenu \
  --prompt "Power" \
  --width 200 \
  --height 200 \
  --lines 4 \
  --cache-file /dev/null \
  --no-actions)

case "$CHOSEN" in
  "  Lock")      hyprlock ;;
  "  Suspend")   systemctl suspend ;;
  "󰜺  Reboot")   systemctl reboot ;;
  "  Shutdown") systemctl poweroff ;;
esac
