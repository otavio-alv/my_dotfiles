#!/usr/bin/env bash
CACHE="$HOME/.cache/ticktickcli/waybar.json"
if [ -s "$CACHE" ]; then
  cat "$CACHE"
else
  echo '{"text":"[ 󰄬 ? ]","tooltip":"Sem dados ainda. Rode: ticktickCLI -waybar","class":"empty"}'
fi