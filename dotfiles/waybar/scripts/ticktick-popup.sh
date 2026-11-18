#!/usr/bin/env bash
# Avoid opening several windows: if one already exists, close it
if swaymsg -t get_tree | grep -q '"app_id": "ticktick_float"'; then
  swaymsg '[app_id="ticktick_float"] kill'
  exit 0
fi

CMD='ticktickCLI -undone | less -R'

kitty --class ticktick_float bash -c "$CMD"
# alacritty: alacritty --class ticktick_float -e bash -c "$CMD"