# my_dotfiles

Dotfiles for my current rice: **Sway (SwayFX) on EndeavourOS/Arch**, dark and minimalist look, with colors dynamically generated from the wallpaper via **pywal**.

## Screenshots

<img width="1920" height="1080" alt="Desktop" src="https://github.com/user-attachments/assets/f0983797-165d-4824-9976-ec500c2d438c" />

<img width="1920" height="1080" alt="Black&White" src="https://github.com/user-attachments/assets/0d32478e-18cd-44ed-9245-03dd90dcb1e5" />

<img width="1920" height="1080" alt="Green" src="https://github.com/user-attachments/assets/32eb54b5-69ef-4d68-b841-274a8b4edb94" />


## Stack

| Role | Tool |
|---|---|
| Distro | EndeavourOS / Arch Linux |
| Compositor | Sway with effects (SwayFX: `blur`, `animation_duration_ms`) |
| Bar | Waybar |
| Launcher | Rofi (`drun` + `calc` modules, `hacker.rasi` theme) |
| Terminal | Kitty (zsh, JetBrainsMono Nerd Font, 90% opacity) |
| Theme/colors | pywal (`wal -i <image>`) + `~/.config/theme/sync-theme.sh` |
| Lock / idle | swaylock-effects (screenshot blur) + swayidle |
| OSD | SwayOSD |
| Keyboard | Custom XKB layout `custom_br` (in `~/.config/xkb/symbols`) |
| Browser / editor / files | Zen Browser, VS Code, Nautilus |
| Fetch | Fastfetch (custom logo) |
| Extras | TickTick in Waybar (CLI + systemd timer), wlsunset, gnome-keyring |

## Structure

```
dotfiles/
├── sway/        config + scripts/start-keyring.sh
├── waybar/      config.jsonc, style.css, scripts/ (bluetooth, powermenu, wlsunset, ticktick)
├── rofi/        config.rasi + themes/ (hacker, blurred, colors-rofi-dark, generated-colors)
├── kitty/       kitty.conf, themes (Medallion, otv, current-theme)
├── swaylock/    config
├── theme/       sync-theme.sh + generated files (palette, sway, kitty, waybar)
├── fastfetch/   config.jsonc, logo.png, logo.txt
└── systemd/user ticktick-cli.service/.timer + *.target.wants
xkb/
├── custom_br    layout used by sway (goes in ~/.config/xkb/symbols/)
└── br           old meuabnt2 variant (system file, legacy)
update.sh        copies the current configs from ~/.config into this repository
```

## Updating the repository

After tweaking the configs in `~/.config`, run:

```bash
./update.sh
```

The script syncs `kitty, rofi, sway, swaylock, systemd, theme, waybar, fastfetch` into `dotfiles/`.

## Dependencies

Official packages/AUR:

```bash
sudo pacman -S --needed sway waybar rofi rofi-calc kitty zsh swayidle \
  grim slurp wl-clipboard playerctl brightnessctl pavucontrol blueman \
  wlsunset polkit-gnome gnome-keyring nautilus python-pywal \
  power-profiles-daemon wireplumber ttf-jetbrains-mono-nerd

# AUR
yay -S swayfx swaylock-effects swayosd zen-browser-bin
```

## Installation

```bash
git clone https://github.com/otavio-alv/my_dotfiles.git ~/my_dotfiles
cd ~/my_dotfiles

# Back up whatever already exists
mkdir -p ~/.config
for d in sway waybar rofi kitty theme fastfetch; do
  [ -e ~/.config/$d ] && mv ~/.config/$d ~/.config/$d.bak
  ln -s ~/my_dotfiles/dotfiles/$d ~/.config/$d
done

# swaylock (sway calls ~/.swaylock/config)
mkdir -p ~/.swaylock && ln -s ~/my_dotfiles/dotfiles/swaylock/config ~/.swaylock/config

# systemd (TickTick timer)
mkdir -p ~/.config/systemd
ln -s ~/my_dotfiles/dotfiles/systemd/user ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now ticktick-cli.timer

# Executable scripts
chmod +x ~/.config/waybar/scripts/*.sh ~/.config/sway/scripts/*.sh

# Theme: generate the colors before starting sway
wal -i ~/Pictures/your-wallpaper.jpg
```

### Keyboard layout (XKB)

Sway uses `xkb_layout custom_br`. The file is read from the user's directory, no `sudo` needed:

```bash
mkdir -p ~/.config/xkb/symbols
cp ~/my_dotfiles/xkb/custom_br ~/.config/xkb/symbols/custom_br
```

## Required adjustments

- **Hardcoded paths:** `sway/config` and `rofi/config.rasi` use the placeholder `/home/USER/...` (`update.sh` generates it automatically). Replace it with your home: `grep -rl /home/USER dotfiles | xargs sed -i "s|/home/USER|$HOME|g"`.
- **Monitors:** `eDP-1` (1920x1080@144Hz) and `HDMI-A-1` (1920x1080@60Hz, on the right). Check yours with `swaymsg -t get_outputs`.
- **Backlight:** Waybar uses `intel_backlight`.

## Main shortcuts (`Super` = Mod4)

| Shortcut | Action |
|---|---|
| `Super+Enter` | Kitty |
| `Super+Space` | Rofi (apps) |
| `Super+W` | Close window |
| `Super+E` | Nautilus |
| `Super+Z` | Zen Browser |
| `Super+C` | Edit the sway config in VS Code |
| `Super+Shift+T` | Sync theme + reload sway |
| `Super+Shift+C` | Reload sway |
| `Super+Shift+E` | Exit sway |
| `Super+M` | Suspend |
| `Super+1..0` | Workspaces (`Shift` moves the window) |
| `Super+H/J/K/L` | Focus (`Shift` moves the window) |
| `Super+R` | Resize mode |
| `Super+B` / `V` | Split horizontal / vertical |
| `Print` | Region screenshot to clipboard |
| `Shift+Print` | Region screenshot to `~/Pictures` |

## Changing the theme

```bash
wal -i path/to/image.jpg   # generates ~/.cache/wal/colors-sway and colors-kitty.conf
# then: Super+Shift+T
```

Sway and Kitty include the generated files from `~/.cache/wal/`. The script `~/.config/theme/sync-theme.sh` (in `dotfiles/theme/`) is called by the shortcut.

- License: see [LICENSE](LICENSE).
