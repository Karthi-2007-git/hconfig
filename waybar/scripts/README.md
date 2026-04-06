# Waybar Config — Hyprland / Arch Linux
## Frosted Glass Dark Aesthetic

---

## 📦 Dependencies

```bash
# Core
sudo pacman -S waybar

# Icons & Fonts
yay -S ttf-jetbrains-mono-nerd ttf-geist-mono-nerd

# Needed for modules
sudo pacman -S playerctl brightnessctl pavucontrol blueman \
               network-manager-applet btop wofi

# Notifications (optional but recommended)
yay -S swaync
```

---

## 🚀 Installation

```bash
# 1. Backup existing config
cp -r ~/.config/waybar ~/.config/waybar.bak 2>/dev/null

# 2. Copy files
mkdir -p ~/.config/waybar/scripts
cp config.jsonc ~/.config/waybar/
cp style.css     ~/.config/waybar/
cp scripts/mediaplayer.py ~/.config/waybar/scripts/
cp scripts/power-menu.sh  ~/.config/waybar/scripts/

# 3. Make scripts executable
chmod +x ~/.config/waybar/scripts/*.py
chmod +x ~/.config/waybar/scripts/*.sh

# 4. Reload Waybar
pkill waybar; waybar &
```

---

## 🎨 Layout

```
[  ][ws1 ws2 ws3…][window title]    [HH:MM]    [media][net][bt][vol][bright][bat][cpu][ram][temp][tray][notif][⏻]
```

---

## ⚙️ Module Reference

| Module | Click | Right-Click | Scroll |
|---|---|---|---|
| Launcher | Open wofi | Color picker | — |
| Clock | Toggle date | — | Navigate calendar |
| Network | — | nm-connection-editor | — |
| Bluetooth | Open blueman | — | — |
| Volume | Open pavucontrol | Toggle mute | ±5% |
| Backlight | — | — | ±5% |
| Battery | — | — | — |
| CPU / RAM | Open btop | — | — |
| Media | Play/Pause | — | Prev/Next |
| Notification | Toggle panel | Toggle DnD | — |
| Power | Power menu | Lock screen | — |

---

## 🔧 Tweaks

**Change terminal emulator** — replace `alacritty` with `kitty` or `foot`:
```jsonc
"on-click": "kitty -e btop"
```

**Fix temperature path** — find your correct hwmon:
```bash
for f in /sys/class/hwmon/hwmon*/temp1_input; do echo "$f: $(cat $f)"; done
```
Then update `hwmon-path` in config.jsonc.

**Fix backlight device** — list yours:
```bash
ls /sys/class/backlight/
```
Update `"device"` in the backlight module accordingly.

**Hyprland — enable blur on Waybar**:
```conf
# hyprland.conf
layerrule = blur, waybar
layerrule = ignorezero, waybar
layerrule = ignorealpha 0.5, waybar
```

---

## 🎨 Color Reference (Catppuccin Mocha)

| Color | Hex | Used for |
|---|---|---|
| Base | `#1e1e2e` | Background |
| Text | `#cdd6f4` | Primary text |
| Blue | `#89b4fa` | Workspaces, wifi |
| Mauve | `#cba6f7` | Volume, RAM |
| Green | `#a6e3a1` | Battery, network |
| Yellow | `#f9e2af` | Backlight, notif |
| Peach | `#fab387` | Temperature |
| Red | `#f38ba8` | Critical, power |
| Teal | `#89dceb` | CPU |
