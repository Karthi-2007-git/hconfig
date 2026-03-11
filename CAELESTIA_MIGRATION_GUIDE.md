# Caelestia Dotfiles Migration Guide

**Date:** March 10, 2026  
**Source:** `/home/karthi/reference/caelestia-main`  
**Target:** `/home/karthi/.config`  
**Shell:** zsh (with fish → zsh alternatives provided)

---

## 📋 Overview

This guide provides a **file-by-file** analysis of your current Arch config vs Caelestia reference dotfiles. Each section explains what Caelestia improves and provides safe merge steps.

---

## 🎯 File-by-File Analysis

### 1. **Hyprland Configuration**

#### Your Current Setup:
- **File:** `~/.config/hypr/hyprland.conf` (monolithic, ~260 lines)
- **Style:** All-in-one config with inline settings
- **Terminal:** kitty
- **Launcher:** rofi
- **Bar:** waybar
- **Autostart:** waybar, hyprpaper, swaync, hypridle

#### Caelestia Setup:
- **File:** `~/.config/hypr/hyprland.conf` (modular, sources many files)
- **Style:** Split into 12+ modular configs in `hypr/hyprland/` folder
- **Terminal:** foot
- **Shell Integration:** quickshell (full desktop shell replacement)
- **Dependencies:** Expects `~/.config/caelestia/` folder for user overrides

#### Modular Structure:
```
caelestia/hypr/
├── hyprland.conf (main entry, sources all below)
├── variables.conf (user-customizable variables)
├── scheme/ (color schemes)
│   └── default.conf
├── scripts/
│   ├── configs.fish (generates user config files)
│   └── wsaction.fish (workspace group navigation)
└── hyprland/
    ├── animations.conf
    ├── decoration.conf (blur, shadows, rounding)
    ├── env.conf (environment variables)
    ├── execs.conf (autostart programs)
    ├── general.conf (gaps, borders, layout)
    ├── gestures.conf
    ├── group.conf
    ├── input.conf
    ├── keybinds.conf (extensive keybinds)
    ├── misc.conf
    ├── rules.conf (window rules)
    └── scrolling.conf
```

#### Key Improvements:
1. **Material Design 3 Color Scheme** - Full palette with semantic colors
2. **Advanced Workspace Groups** - 10 workspace groups (100 total workspaces)
3. **Global Shortcuts** - DBus integration for shell IPC
4. **Modular Organization** - Easy to override specific sections
5. **Better Animations** - Emphasized decel/accel bezier curves
6. **Special Workspaces** - Dedicated toggles for sysmon, music, communication, todo

#### Migration Strategy:

**Option A: Hybrid Approach (RECOMMENDED)**
Keep your current `hyprland.conf` and cherry-pick improvements:

1. **Copy color scheme:**
   ```bash
   cp -r ~/reference/caelestia-main/hypr/scheme ~/.config/hypr/
   ```

2. **Add to your hyprland.conf:**
   ```conf
   # Source Caelestia colors
   source = ~/.config/hypr/scheme/default.conf
   
   # Apply to borders (example)
   general {
       col.active_border = $primary
       col.inactive_border = $outlineVariant
   }
   ```

3. **Keep your existing keybinds, monitor, autostart**

**Option B: Full Migration**
1. Backup current config: `cp -r ~/.config/hypr ~/.config/hypr.backup`
2. Copy Caelestia hypr folder: `cp -r ~/reference/caelestia-main/hypr ~/.config/`
3. Create user override files:
   ```bash
   mkdir -p ~/.config/caelestia
   touch ~/.config/caelestia/hypr-vars.conf
   touch ~/.config/caelestia/hypr-user.conf
   ```
4. Add your monitor config to `~/.config/caelestia/hypr-vars.conf`:
   ```conf
   monitor = eDP-1,2560x1600@165.00,auto,1.25
   ```
5. Add your custom keybinds/settings to `~/.config/caelestia/hypr-user.conf`
6. Update variables in `~/.config/hypr/variables.conf`:
   ```conf
   $terminal = kitty  # Change from foot
   $browser = zen-browser  # or your browser
   $editor = code  # or codium
   $fileExplorer = nemo  # keep nemo
   ```

**⚠️ Note:** Caelestia expects the quickshell desktop shell. If you want to keep waybar:
- Keep your autostart: `exec-once = waybar`
- Remove or comment: `exec-once = caelestia shell -d` from `hypr/hyprland/execs.conf`

---

### 2. **Fastfetch**

#### Your Current:
- Custom bordered layout with icons
- OS age calculation
- 17 info modules
- Uses `~/.config/fastfetch/arch.txt` logo

#### Caelestia:
- Minimal compact layout
- 10 info modules
- No custom ASCII art logo
- Simpler output

#### Recommendation:
**Keep your current config** - It's more detailed and visually appealing. Caelestia's is too minimal.

Optional: Copy their color constants if you like:
```jsonc
"display": {
    "constants": ["\u001b[37m", "\u001b[38;5;16m", "\u001b[38;5;17m", "\u001b[38;5;18m"]
}
```

---

### 3. **btop**

#### Differences:
| Setting | Your Config | Caelestia |
|---------|-------------|-----------|
| color_theme | "matugen" | "caelestia" |
| theme_background | true | false |

#### Action:
Both are nearly identical. **Keep yours** unless you want the Caelestia theme:

```bash
# Copy Caelestia btop theme if it exists
cp ~/reference/caelestia-main/btop/themes/* ~/.config/btop/themes/ 2>/dev/null || echo "No themes folder"
```

Then change in `~/.config/btop/btop.conf`:
```conf
color_theme = "caelestia"
theme_background = false  # For transparency
```

---

### 4. **Shell Configuration (fish → zsh)**

#### Caelestia fish config features:
```fish
# Starship prompt
starship init fish | source

# Tools integration
direnv hook fish | source
zoxide init fish --cmd cd | source

# Better ls with eza
alias ls='eza --icons --group-directories-first -1'

# Git abbreviations
abbr ga 'git add .'
abbr gc 'git commit -am'
# ... etc

# Custom colors from Caelestia
cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
```

#### Your Current zsh:
- powerlevel10k prompt
- Oh My Zsh
- zoxide
- eza aliases (already have!)
- zsh-autosuggestions
- zsh-syntax-highlighting

#### Migration to zsh equivalents:

**Add to your `~/.zshrc` (after Oh My Zsh loads):**

```bash
# === Caelestia-inspired additions ===

# Option 1: Keep powerlevel10k (you already have it)
# Option 2: Switch to starship (optional, more minimalist)
# eval "$(starship init zsh)"  # Uncomment if you want starship

# Git aliases (Caelestia style)
alias ga='git add .'
alias gc='git commit -am'
alias gd='git diff'
alias gl='git log'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsm='git switch main'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gsh='git show'
alias lg='lazygit'

# Better ls (you already have eza, add group-directories-first)
alias ls='eza --icons --group-directories-first'
alias l='ls'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -lha --icons --git --group-directories-first'
alias lla='la'

# Direnv if installed
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# Load Caelestia terminal colors (if using Caelestia shell)
[ -f ~/.local/state/caelestia/sequences.txt ] && cat ~/.local/state/caelestia/sequences.txt

# Foot terminal prompt markers (for jumping between prompts)
# Only if using foot terminal
if [[ "$TERM" == "foot" ]]; then
    precmd() {
        print -Pn "\e]133;A\e\\"
    }
fi
```

**If you want starship instead of powerlevel10k:**
1. Install starship: `yay -S starship` (no install prompt - just noting)
2. Copy Caelestia config:
   ```bash
   cp ~/reference/caelestia-main/starship.toml ~/.config/starship.toml
   ```
3. Replace in `~/.zshrc`:
   ```bash
   # Comment out: ZSH_THEME="powerlevel10k/powerlevel10k"
   # Add after Oh My Zsh: eval "$(starship init zsh)"
   ```

---

### 5. **Kitty Terminal**

#### Your Config:
- MesloLGS Nerd Font
- Zsh shell
- Beam cursor with trail
- 0.85 opacity
- Custom window size (1000×700)

#### Caelestia Alternative:
- Uses **foot terminal** (not kitty)
- Has `foot/foot.ini` config

#### Recommendation:
**Keep your kitty config** - It's well-tuned. 

Optional enhancements from Caelestia style:
```conf
# Add Material Design colors from Caelestia scheme
# You can source the color values from:
# ~/reference/caelestia-main/hypr/scheme/default.conf

# Example color mapping:
background #131317
foreground #e5e1e7
cursor #c2c1ff
selection_background #2a292e
selection_foreground #e5e1e7

# Additional Material colors (add to kitty.conf)
color0 #353434
color1 #ac73ff
color2 #44def5
color3 #ffdcf2
color4 #99aad8
color5 #b49fea
color6 #9dceff
color7 #e8d3de
color8 #ac9fa9
color9 #c093ff
color10 #89ecff
color11 #fff0f6
color12 #b5c1dd
color13 #c9b5f4
color14 #bae0ff
color15 #ffffff
```

---

### 6. **Waybar**

#### Your Current:
- Simple config with modules: workspaces, clock, mpris, backlight, pulseaudio, network, cpu, memory, battery, tray
- Clean styling with JetBrainsMono font
- Semi-transparent background (0.85 opacity)

#### Caelestia:
- **Does NOT use Waybar** - uses quickshell custom bar
- If you want to keep waybar (recommended for stability), no changes needed

#### Recommendation:
**Keep your waybar config as-is.** Caelestia's shell is a full replacement but requires:
- Installing quickshell-git (AUR package)
- Installing caelestia-cli
- Many dependencies

For a stable system, keep waybar until you're ready to test the full Caelestia shell.

---

### 7. **Hyprlock / Hypridle**

#### Your Current:
- Custom hyprlock with shutdown/reboot/logout buttons
- Profile image support
- Battery, WiFi, Bluetooth info
- Media player info
- Timeouts: 600s lock, 900s DPMS off, 1800s suspend

#### Caelestia:
- Uses the Caelestia shell lock screen (integrated)
- Simpler lock mechanism

#### Recommendation:
**Keep your current hyprlock/hypridle setup** - It's feature-rich and works independently.

Your lock script (`~/.config/hypr/hyprlock/scripts/hyprlock.sh`) is good - it pauses media and mutes audio.

---

### 8. **Additional Caelestia Files**

#### Fish Shell Config
Already converted above to zsh equivalents.

#### Foot Terminal
You use kitty - no need to adopt foot.

#### Micro Editor
Caelestia includes `micro/settings.json` - only relevant if you use micro editor.

#### Thunar File Manager
Caelestia includes:
- `thunar/thunar-volman.xml` (removable media handling)
- `thunar/uca.xml` (custom actions)

If you use thunar, you can copy these:
```bash
mkdir -p ~/.config/thunar
cp ~/reference/caelestia-main/thunar/* ~/.config/thunar/
```

#### UWSM (Universal Wayland Session Manager)
Caelestia includes `uwsm/env` and `uwsm/env-hyprland` for session environment setup.

Only copy if you use uwsm:
```bash
mkdir -p ~/.config/uwsm
cp ~/reference/caelestia-main/uwsm/* ~/.config/uwsm/
```

#### VS Code / Zed
If you use these editors, Caelestia has configs:
```bash
# VS Code / VSCodium
cp ~/reference/caelestia-main/vscode/settings.json ~/.config/Code/User/
cp ~/reference/caelestia-main/vscode/keybindings.json ~/.config/Code/User/

# Zed
cp ~/reference/caelestia-main/zed/settings.json ~/.config/zed/
```

---

## 🐚 Fish Scripts → Zsh Conversion

### Script 1: `configs.fish` (Config File Generator)

**Original (fish):**
```fish
#!/usr/bin/env fish
set -l _reload false

if ! test -d $argv
    mkdir -p $argv
end

if ! test -f $argv/hypr-vars.conf
    touch -a $argv/hypr-vars.conf
    set -l _reload true
end

if ! test -f $argv/hypr-user.conf
    touch -a $argv/hypr-user.conf
    set -l _reload true
end

if _reload
    hyprctl reload
end
```

**Zsh equivalent:**
```bash
#!/usr/bin/env zsh

_reload=false

[[ ! -d "$1" ]] && mkdir -p "$1"

if [[ ! -f "$1/hypr-vars.conf" ]]; then
    touch "$1/hypr-vars.conf"
    _reload=true
fi

if [[ ! -f "$1/hypr-user.conf" ]]; then
    touch "$1/hypr-user.conf"
    _reload=true
fi

[[ "$_reload" == "true" ]] && hyprctl reload
```

Save as: `~/.config/hypr/scripts/configs.zsh`

---

### Script 2: `wsaction.fish` (Workspace Group Navigation)

**Original (fish):**
```fish
#!/usr/bin/env fish

if test "$argv[1]" = '-g'
    set group
    set -e $argv[1]
end

if test (count $argv) -ne 2
    echo 'Wrong number of arguments. Usage: ./wsaction.fish [-g] <dispatcher> <workspace>'
    exit 1
end

set -l active_ws (hyprctl activeworkspace -j | jq -r '.id')

if set -q group
    # Move to group
    hyprctl dispatch $argv[1] (math "($argv[2] - 1) * 10 + $active_ws % 10")
else
    # Move to ws in group
    hyprctl dispatch $argv[1] (math "floor(($active_ws - 1) / 10) * 10 + $argv[2]")
end
```

**Zsh equivalent:**
```bash
#!/usr/bin/env zsh

group=false
if [[ "$1" == "-g" ]]; then
    group=true
    shift
fi

if [[ $# -ne 2 ]]; then
    echo 'Wrong number of arguments. Usage: ./wsaction.zsh [-g] <dispatcher> <workspace>'
    exit 1
fi

active_ws=$(hyprctl activeworkspace -j | jq -r '.id')

if [[ "$group" == "true" ]]; then
    # Move to group
    target=$(( ($2 - 1) * 10 + $active_ws % 10 ))
else
    # Move to ws in group
    target=$(( ($active_ws - 1) / 10 * 10 + $2 ))
fi

hyprctl dispatch "$1" "$target"
```

Save as: `~/.config/hypr/scripts/wsaction.zsh`

**Make executable:**
```bash
chmod +x ~/.config/hypr/scripts/configs.zsh
chmod +x ~/.config/hypr/scripts/wsaction.zsh
```

**Update hyprland.conf if using Caelestia keybinds:**
Change all references from `.fish` to `.zsh`:
```conf
$wsaction = ~/.config/hypr/scripts/wsaction.zsh
```

---

## 📦 Safe Execution Sequence

### Phase 1: Non-Breaking Visual Improvements (Safe)

```bash
# 1. Backup everything first
cd ~/.config
tar -czf ~/config-backup-$(date +%Y%m%d).tar.gz .

# 2. Copy Caelestia color scheme
mkdir -p ~/.config/hypr/scheme
cp ~/reference/caelestia-main/hypr/scheme/default.conf ~/.config/hypr/scheme/

# 3. Add color source to your hyprland.conf (add at top)
echo 'source = ~/.config/hypr/scheme/default.conf' >> ~/.config/hypr/hyprland.conf.tmp
cat ~/.config/hypr/hyprland.conf >> ~/.config/hypr/hyprland.conf.tmp
mv ~/.config/hypr/hyprland.conf.tmp ~/.config/hypr/hyprland.conf

# 4. Update border colors in hyprland.conf general block
# Edit manually: Replace col.active_border and col.inactive_border with:
#   col.active_border = $primary
#   col.inactive_border = $outlineVariant

# 5. Reload Hyprland
hyprctl reload
```

### Phase 2: Shell Enhancements (Medium Risk)

```bash
# 1. Copy starship config
cp ~/reference/caelestia-main/starship.toml ~/.config/starship.toml

# 2. Add zsh aliases to ~/.zshrc (see section above)
# Edit ~/.zshrc and add the git aliases and enhanced ls aliases

# 3. Optional: Switch to starship
# Edit ~/.zshrc, comment out powerlevel10k, add:
# eval "$(starship init zsh)"

# 4. Reload shell
source ~/.zshrc
```

### Phase 3: Modular Hyprland (Higher Risk - Full Migration)

**⚠️ Only do this if you want the full Caelestia setup**

```bash
# 1. Create backup
cp -r ~/.config/hypr ~/.config/hypr.backup-full

# 2. Copy all Caelestia hypr configs
rm -rf ~/.config/hypr
cp -r ~/reference/caelestia-main/hypr ~/.config/

# 3. Create user override directory
mkdir -p ~/.config/caelestia

# 4. Add your monitor config
cat > ~/.config/caelestia/hypr-vars.conf << 'EOF'
monitor = eDP-1,2560x1600@165.00,auto,1.25
EOF

# 5. Add your custom settings
cat > ~/.config/caelestia/hypr-user.conf << 'EOF'
# Keep waybar instead of caelestia shell
exec-once = waybar

# Your custom keybinds
bind = Super, Q, exec, kitty  # Keep kitty terminal
EOF

# 6. Update terminal in variables.conf
sed -i 's/$terminal = foot/$terminal = kitty/' ~/.config/hypr/variables.conf

# 7. Convert fish scripts to zsh
cp ~/reference/caelestia-main/hypr/scripts/configs.fish ~/.config/hypr/scripts/configs.zsh
cp ~/reference/caelestia-main/hypr/scripts/wsaction.fish ~/.config/hypr/scripts/wsaction.zsh
# Then manually convert using examples above

# 8. Update script references in keybinds.conf
sed -i 's/\.fish/.zsh/g' ~/.config/hypr/hyprland/keybinds.conf

# 9. Reload
hyprctl reload
```

### Phase 4: Caelestia Shell (Advanced - Requires Packages)

**⚠️ This requires installing multiple AUR packages. I won't do this without your explicit permission.**

Required packages:
- `quickshell-git`
- `caelestia-cli`
- `caelestia-shell` (or manual install from git)

This replaces waybar entirely with a custom Qt-based shell.

---

## 🎨 Color Scheme Reference

Caelestia uses Material Design 3 with these key colors:

```conf
# Primary (Accent)
$primary = c2c1ff          # Soft purple
$onPrimary = 2a2a60        # Dark purple text

# Surface (Backgrounds)
$background = 131317       # Very dark
$surface = 131317          # Same as background
$surfaceContainer = 201f23 # Slightly lighter

# Text
$onBackground = e5e1e7     # Light text
$onSurface = e5e1e7        # Same

# Borders/Outlines
$outline = 918f9a          # Medium gray
$outlineVariant = 47464f   # Darker gray

# Terminal colors (16 color palette)
color0-15 defined with purple/blue/pink accents
```

You can use these in:
- Hyprland borders
- Waybar CSS
- Kitty terminal
- Rofi themes
- Any app that supports color customization

---

## 🔧 Recommended Hybrid Setup

**Best of both worlds:**

1. ✅ **Keep your current:**
   - Waybar (stable, familiar)
   - Kitty terminal (well-configured)
   - Hyprlock/hypridle (feature-rich)
   - Basic monolithic hyprland.conf structure

2. ✅ **Adopt from Caelestia:**
   - Color scheme (Material Design 3)
   - Git aliases in zsh
   - Starship prompt (optional)
   - Workspace group scripts (if you want 100 workspaces)
   - Better animation curves

3. ❌ **Skip for now:**
   - Quickshell desktop shell (complex, many dependencies)
   - Full modular hyprland structure (unnecessary if current works)
   - Foot terminal (kitty is great)
   - Fish shell (you're on zsh)

---

## 🚀 Quick Start Commands

**Minimal safe improvements:**
```bash
# Colors only
mkdir -p ~/.config/hypr/scheme
cp ~/reference/caelestia-main/hypr/scheme/default.conf ~/.config/hypr/scheme/
# Then manually add: source = ~/.config/hypr/scheme/default.conf to hyprland.conf

# Better animations
cp ~/reference/caelestia-main/hypr/hyprland/animations.conf ~/.config/hypr/
# Then add: source = ~/.config/hypr/animations.conf to hyprland.conf

# Git aliases
cat >> ~/.zshrc << 'EOF'

# Caelestia git aliases
alias ga='git add .'
alias gc='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
EOF

source ~/.zshrc
```

---

## 📝 Notes

- **No packages will be installed without your permission**
- All changes are file copies/edits only
- Your current setup is backed up before any changes
- You can mix and match - take only what you want
- Rollback: `cp -r ~/.config/hypr.backup ~/.config/hypr`

---

## 🆘 Troubleshooting

**If Hyprland won't start after changes:**
```bash
# Restore backup
cp -r ~/.config/hypr.backup ~/.config/hypr
# Or check logs:
cat /tmp/hypr/$(ls -t /tmp/hypr | head -1)/hyprland.log
```

**If shell looks weird:**
```bash
# Restore zshrc
cp ~/.zshrc.backup ~/.zshrc
source ~/.zshrc
```

**If colors are wrong:**
```bash
# Remove color source from hyprland.conf
sed -i '/scheme\/default.conf/d' ~/.config/hypr/hyprland.conf
hyprctl reload
```

---

## ✨ What's Next?

1. Read this guide thoroughly
2. Decide which parts you want (colors? animations? shell aliases?)
3. Follow the safe execution sequence for your choices
4. Test each change before moving to the next
5. Ask me to implement specific sections when ready

**Example:** "Apply Phase 1 color improvements only" or "Add the git aliases to my zshrc"
