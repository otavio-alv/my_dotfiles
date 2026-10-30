# my_dotfiles

My current rice, based on **Sway (SwayFX) on EndeavourOS/Arch**, with a dark, minimalist ASCII look and colors generated dynamically from the wallpaper via **pywal**.

Feel free to take inspiration; these are personal configs, not a distro!

## Screenshots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c00911dd-e806-4cef-a0b3-9c1253487157" />
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/962c73eb-cffb-44d7-bf0e-58bbba8415d0" />
<img width="1918" height="1080" alt="image" src="https://github.com/user-attachments/assets/a2bc0cac-563a-44cd-ad50-40d3d0d92509" />


## Stack

| Role | Tool |
|---|---|
| Distro | EndeavourOS / Arch Linux |
| Compositor | Sway(FX) |
| Bar | Waybar |
| Launcher | Rofi |
| Terminal | Kitty / zsh |
| Theming/colors | pywal |
| Keyboard | Custom XKB layout `br(meuabnt2)` |

## Dependencies

Official/AUR packages (names may vary; check with `yay -Ss`):

```bash
sudo pacman -S --needed sway waybar rofi rofi-calc kitty zsh swayidle \
  grim slurp wl-clipboard playerctl brightnessctl pavucontrol blueman \
  wlsunset polkit-gnome gnome-keyring nautilus python-pywal \
  power-profiles-daemon wireplumber

# AUR
yay -S swayfx swaylock-effects swayosd zen-browser-bin
```

> Also used: `xfce4-power-manager`, `code` (VS Code) and `nmgui` (right-click on the network module).

> `swayfx` replaces the `sway` package (they conflict). If you use SwayFX, do not install regular `sway`.

## Installation

```bash
git clone https://github.com/otavio-alv/my_dotfiles.git ~/my_dotfiles
cd ~/my_dotfiles

# Back up anything that already exists
mkdir -p ~/.config
for d in sway waybar rofi kitty; do
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

# Make scripts executable
chmod +x ~/.config/waybar/scripts/*.sh ~/.config/sway/scripts/*.sh

# Fonts (from the repo assets)
mkdir -p ~/.local/share/fonts
cp -r ~/my_dotfiles/assets/fonts/JetBrainsMono ~/.local/share/fonts/
cp -r ~/my_dotfiles/assets/fonts/EnvyCodeR ~/.local/share/fonts/
fc-cache -fv

# Theme: generate the colors before starting sway
wal -i ~/my_dotfiles/assets/wallpapers/holy.png
```

## Included fonts

| Font | Used in | Files in the repo |
|---|---|---|
| **JetBrains Mono** | Kitty | `assets/fonts/JetBrainsMono/` (Regular, Bold, Italic, Light, Medium, SemiBold, ExtraBold, Thin + NL variants) |
| **Envy Code R Nerd Font** | Rofi, Waybar | `assets/fonts/EnvyCodeR/` (Regular, Bold, Italic + Mono and Propo variants) |

## Keyboard layout (XKB)

Sway uses `xkb_layout br` + `xkb_variant meuabnt2`. The variant lives in `xkb/br` and must be installed on the system:

```bash
sudo cp /usr/share/X11/xkb/symbols/br /usr/share/X11/xkb/symbols/br.bak
sudo cp ~/my_dotfiles/xkb/br /usr/share/X11/xkb/symbols/br
```

`meuabnt2` is the standard ABNT2 layout with AltGr+E = `\`, AltGr+Z = `|` and AltGr+R = `°`. Updates to the `xkeyboard-config` package may overwrite the file.

## Required tweaks

- **Hardcoded paths:** `sway/config` and `rofi/config.rasi` use `/home/otavioalv/...`. Replace with your username (`sed -i 's|/home/otavioalv|'"$HOME"'|g' ...`).
- **Monitors:** `eDP-1` (1920x1080@144Hz) and `HDMI-A-1` (1920x1080@60Hz, on the right). Check yours with `swaymsg -t get_outputs`.
- **Backlight:** Waybar uses `intel_backlight`.
- **SSH:** the config references the key `~/.ssh/gitkey`.
- **TickTick:** depends on the `~/.local/bin/ticktickCLI` binary, which is **not in this repository**. Without it, disable the `custom/ticktick` module.
- **Waybar:** the `waybar/waybar/` folder seems to be a leftover from Waybar Configurator; what matters is `config.jsonc` + `style.css`.

## Main keybindings (`Super` = Mod4)

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
| `Print` | Screenshot of a region to the clipboard |
| `Shift+Print` | Screenshot of a region to `~/Pictures` |

## Changing the theme

```bash
wal -i path/to/image.jpg   # generates ~/.cache/wal/colors-sway and colors-kitty.conf
# then: Super+Shift+T
```
