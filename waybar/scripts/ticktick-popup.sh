#!/usr/bin/env bash
# Evita abrir várias janelas: se já existir, fecha
if swaymsg -t get_tree | grep -q '"app_id": "ticktick_float"'; then
  swaymsg '[app_id="ticktick_float"] kill'
  exit 0
fi

CMD='ticktickCLI -undone | less -R'

kitty --class ticktick_float bash -c "$CMD"
# alacritty: alacritty --class ticktick_float -e bash -c "$CMD"