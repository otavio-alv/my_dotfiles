#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="${HOME}/.config/theme"
PALETTE_FILE="${THEME_DIR}/palette.conf"

if [[ ! -f "${PALETTE_FILE}" ]]; then
  echo "Arquivo de paleta não encontrado: ${PALETTE_FILE}" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "${PALETTE_FILE}"

required_vars=(
  THEME_BG
  THEME_FG
  THEME_ACCENT
  THEME_BORDER_FOCUS
  THEME_BORDER_INACTIVE
  THEME_URGENT
  THEME_HOVER_BG
  THEME_MUTED
)

for v in "${required_vars[@]}"; do
  if [[ -z "${!v:-}" ]]; then
    echo "Variável obrigatória ausente em palette.conf: ${v}" >&2
    exit 1
  fi
done

normalize_color() {
  local c="$1"
  if [[ "$c" =~ ^#[0-9A-Fa-f]{8}$ ]]; then
    echo "#${c:1:6}"
  else
    echo "$c"
  fi
}

N_THEME_BG="$(normalize_color "${THEME_BG}")"
N_THEME_FG="$(normalize_color "${THEME_FG}")"
N_THEME_ACCENT="$(normalize_color "${THEME_ACCENT}")"
N_THEME_BORDER_FOCUS="$(normalize_color "${THEME_BORDER_FOCUS}")"
N_THEME_BORDER_INACTIVE="$(normalize_color "${THEME_BORDER_INACTIVE}")"
N_THEME_URGENT="$(normalize_color "${THEME_URGENT}")"
N_THEME_HOVER_BG="$(normalize_color "${THEME_HOVER_BG}")"
N_THEME_MUTED="$(normalize_color "${THEME_MUTED}")"
N_THEME_ROFI_ACCENT="$(normalize_color "${THEME_ROFI_ACCENT:-${THEME_ACCENT}}")"
N_THEME_ROFI_SELECT_BG="$(normalize_color "${THEME_ROFI_SELECT_BG:-${THEME_HOVER_BG}}")"

cat > "${THEME_DIR}/sway-theme.conf" <<EOF
# Arquivo gerado automaticamente por sync-theme.sh
set \$theme_bg ${N_THEME_BG}
set \$theme_fg ${N_THEME_FG}
set \$theme_accent ${N_THEME_ACCENT}
set \$theme_focus_border ${N_THEME_BORDER_FOCUS}
set \$theme_inactive_border ${N_THEME_BORDER_INACTIVE}
set \$theme_urgent ${N_THEME_URGENT}
set \$theme_hover_bg ${N_THEME_HOVER_BG}
set \$theme_muted ${N_THEME_MUTED}

client.focused          \$theme_focus_border \$theme_bg \$theme_fg \$theme_focus_border \$theme_focus_border
client.focused_inactive \$theme_inactive_border \$theme_bg \$theme_fg \$theme_inactive_border \$theme_inactive_border
client.unfocused        \$theme_inactive_border \$theme_bg \$theme_fg \$theme_inactive_border \$theme_inactive_border
client.urgent           \$theme_urgent \$theme_bg \$theme_fg \$theme_urgent \$theme_urgent
client.placeholder      \$theme_muted \$theme_bg \$theme_fg \$theme_muted \$theme_muted
EOF

cat > "${THEME_DIR}/waybar-colors.css" <<EOF
/* Arquivo gerado automaticamente por sync-theme.sh */
@define-color theme_bg ${N_THEME_BG};
@define-color theme_fg ${N_THEME_FG};
@define-color theme_accent ${N_THEME_ACCENT};
@define-color theme_border_focus ${N_THEME_BORDER_FOCUS};
@define-color theme_border_inactive ${N_THEME_BORDER_INACTIVE};
@define-color theme_urgent ${N_THEME_URGENT};
@define-color theme_hover_bg ${N_THEME_HOVER_BG};
@define-color theme_muted ${N_THEME_MUTED};
EOF

cat > "${THEME_DIR}/kitty-theme.conf" <<EOF
# Arquivo gerado automaticamente por sync-theme.sh
foreground ${N_THEME_FG}
background ${N_THEME_BG}
cursor ${N_THEME_ACCENT}
selection_foreground ${N_THEME_BG}
selection_background ${N_THEME_FG}

active_border_color ${N_THEME_ACCENT}
inactive_border_color ${N_THEME_BORDER_INACTIVE}

color0 ${N_THEME_BG}
color1 ${N_THEME_ACCENT}
color2 ${N_THEME_FG}
color3 ${N_THEME_FG}
color4 ${N_THEME_BORDER_FOCUS}
color5 ${N_THEME_BORDER_INACTIVE}
color6 ${N_THEME_HOVER_BG}
color7 ${N_THEME_FG}
color8 ${N_THEME_MUTED}
color9 ${N_THEME_ACCENT}
color10 ${N_THEME_FG}
color11 ${N_THEME_FG}
color12 ${N_THEME_ACCENT}
color13 ${N_THEME_BORDER_INACTIVE}
color14 ${N_THEME_HOVER_BG}
color15 ${N_THEME_FG}
EOF

cat > "${HOME}/.config/rofi/themes/generated-colors.rasi" <<EOF
/* Arquivo gerado automaticamente por sync-theme.sh */
* {
  bg-col:       ${N_THEME_BG};
  input-col:    ${N_THEME_MUTED};
  fg-col:       ${N_THEME_FG};
  accent-col:   ${N_THEME_ROFI_ACCENT};
  select-bg:    ${N_THEME_ROFI_SELECT_BG};
  border-col:   ${N_THEME_BORDER_FOCUS};
}
EOF

if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
  if pgrep -x waybar >/dev/null 2>&1; then
    pkill -SIGUSR2 waybar || true
  else
    nohup waybar >/dev/null 2>&1 &
  fi
fi

echo "Tema sincronizado em sway, waybar, kitty e rofi."
