# my_dotfiles

Dotfiles do meu rice atual: **Sway (SwayFX) no EndeavourOS/Arch**, visual escuro e minimalista, com cores geradas dinamicamente a partir do wallpaper via **pywal**.

## Stack

| Função | Ferramenta |
|---|---|
| Distro | EndeavourOS / Arch Linux |
| Compositor | Sway com efeitos (SwayFX: `blur`, `animation_duration_ms`) |
| Barra | Waybar |
| Launcher | Rofi (módulos `drun` + `calc`, tema `hacker.rasi`) |
| Terminal | Kitty (zsh, JetBrainsMono Nerd Font, 90% de opacidade) |
| Tema/cores | pywal (`wal -i <imagem>`) + `~/.config/theme/sync-theme.sh` |
| Lock / idle | swaylock-effects (blur do screenshot) + swayidle |
| OSD | SwayOSD |
| Teclado | Layout XKB próprio `custom_br` (em `~/.config/xkb/symbols`) |
| Navegador / editor / arquivos | Zen Browser, VS Code, Nautilus |
| Fetch | Fastfetch (logo próprio) |
| Extras | TickTick na Waybar (CLI + systemd timer), wlsunset, gnome-keyring |

## Estrutura

```
dotfiles/
├── sway/        config + scripts/start-keyring.sh
├── waybar/      config.jsonc, style.css, scripts/ (bluetooth, powermenu, wlsunset, ticktick)
├── rofi/        config.rasi + themes/ (hacker, blurred, colors-rofi-dark, generated-colors)
├── kitty/       kitty.conf, temas (Medallion, otv, current-theme)
├── swaylock/    config
├── theme/       sync-theme.sh + arquivos gerados (palette, sway, kitty, waybar)
├── fastfetch/   config.jsonc, logo.png, logo.txt
└── systemd/user ticktick-cli.service/.timer + *.target.wants
xkb/
├── custom_br    layout usado pelo sway (vai em ~/.config/xkb/symbols/)
└── br           variante meuabnt2 antiga (arquivo de sistema, legado)
update.sh        copia as configs atuais de ~/.config para este repositório
```

## Atualizar o repositório

Depois de mexer nas configs em `~/.config`, rode:

```bash
./update.sh
```

O script sincroniza `kitty, rofi, sway, swaylock, systemd, theme, waybar, fastfetch` para `dotfiles/` (com `rsync --delete`, então arquivos removidos na origem somem do repositório) e copia `~/.config/xkb/symbols/*` para `xkb/`. Ele não faz commit.

## Dependências

Pacotes oficiais/AUR (nomes podem variar; confira com `yay -Ss`):

```bash
sudo pacman -S --needed sway waybar rofi rofi-calc kitty zsh swayidle \
  grim slurp wl-clipboard playerctl brightnessctl pavucontrol blueman \
  wlsunset polkit-gnome gnome-keyring nautilus python-pywal \
  power-profiles-daemon wireplumber ttf-jetbrains-mono-nerd

# AUR
yay -S swayfx swaylock-effects swayosd zen-browser-bin
```

Também usados: fonte **Envy Code R Nerd Font** (Rofi), `xfce4-power-manager`, `code` (VS Code) e `nmgui` (clique direito na rede).

> `swayfx` substitui o pacote `sway` (conflitam). Se usar SwayFX, não instale o `sway` comum.

## Instalação

```bash
git clone https://github.com/otavio-alv/my_dotfiles.git ~/my_dotfiles
cd ~/my_dotfiles

# Faça backup do que já existir
mkdir -p ~/.config
for d in sway waybar rofi kitty theme fastfetch; do
  [ -e ~/.config/$d ] && mv ~/.config/$d ~/.config/$d.bak
  ln -s ~/my_dotfiles/dotfiles/$d ~/.config/$d
done

# swaylock (o sway chama ~/.swaylock/config)
mkdir -p ~/.swaylock && ln -s ~/my_dotfiles/dotfiles/swaylock/config ~/.swaylock/config

# systemd (timer do TickTick)
mkdir -p ~/.config/systemd
ln -s ~/my_dotfiles/dotfiles/systemd/user ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now ticktick-cli.timer

# Scripts executáveis
chmod +x ~/.config/waybar/scripts/*.sh ~/.config/sway/scripts/*.sh

# Tema: gere as cores antes de iniciar o sway
wal -i ~/Pictures/seu-wallpaper.jpg
```

### Layout de teclado (XKB)

O sway usa `xkb_layout custom_br`. O arquivo é lido do diretório do usuário, sem precisar de `sudo`:

```bash
mkdir -p ~/.config/xkb/symbols
cp ~/my_dotfiles/xkb/custom_br ~/.config/xkb/symbols/custom_br
```

É o ABNT2 padrão com AltGr+E = `\`, AltGr+Z = `|` e AltGr+R = `°`. Como fica em `~/.config`, não é sobrescrito por atualizações do `xkeyboard-config`.

> `xkb/br` é a versão antiga (variante `meuabnt2`, instalada em `/usr/share/X11/xkb/symbols/br`). Não é mais usada pelo sway e não é atualizada pelo `update.sh`.

## Ajustes obrigatórios

- **Caminhos fixos:** o `sway/config` e o `rofi/config.rasi` usam o placeholder `/home/USER/...` (o `update.sh` o gera automaticamente). Troque pelo seu home: `grep -rl /home/USER dotfiles | xargs sed -i "s|/home/USER|$HOME|g"`.
- **Monitores:** `eDP-1` (1920x1080@144Hz) e `HDMI-A-1` (1920x1080@60Hz, à direita). Veja os seus com `swaymsg -t get_outputs`.
- **Backlight:** a Waybar usa `intel_backlight`.
- **TickTick:** depende do binário `~/.local/bin/ticktickCLI`, que **não está neste repositório**. Sem ele, desative o módulo `custom/ticktick`.
- **Waybar:** a pasta `waybar/waybar/` parece ser resquício do Waybar Configurator; o que vale é `config.jsonc` + `style.css`.

## Atalhos principais (`Super` = Mod4)

| Atalho | Ação |
|---|---|
| `Super+Enter` | Kitty |
| `Super+Space` | Rofi (apps) |
| `Super+W` | Fechar janela |
| `Super+E` | Nautilus |
| `Super+Z` | Zen Browser |
| `Super+C` | Editar o config do sway no VS Code |
| `Super+Shift+T` | Sincronizar tema + recarregar o sway |
| `Super+Shift+C` | Recarregar o sway |
| `Super+Shift+E` | Sair do sway |
| `Super+M` | Suspender |
| `Super+1..0` | Workspaces (`Shift` move a janela) |
| `Super+H/J/K/L` | Foco (`Shift` move a janela) |
| `Super+R` | Modo resize |
| `Super+B` / `V` | Split horizontal / vertical |
| `Print` | Print de região para o clipboard |
| `Shift+Print` | Print de região para `~/Pictures` |

Gestos no touchpad: swipe esquerda/direita troca de workspace. O lock ocorre após 5 min de inatividade e a suspensão após 10 min.

## Trocar o tema

```bash
wal -i caminho/da/imagem.jpg   # gera ~/.cache/wal/colors-sway e colors-kitty.conf
# depois: Super+Shift+T
```

O Sway e o Kitty incluem os arquivos gerados em `~/.cache/wal/`. O script `~/.config/theme/sync-theme.sh` (em `dotfiles/theme/`) é chamado pelo atalho.

## Observações

- Cabeçalho do `sway/config` credita "WildGothitelle" como base.
- `kitty.conf.bak` e temas não usados (Medallion, otv) estão apenas como referência.
- Licença: veja [LICENSE](LICENSE).
