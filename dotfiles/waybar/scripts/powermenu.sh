#!/usr/bin/env bash

SHUTDOWN="󰐥  Desligar"
REBOOT="󰑐  Reiniciar"
SUSPEND="󰒲  Suspender"
CANCEL="  Cancelar"

CHOICE=$(printf "%s\n%s\n%s\n%s" "$SHUTDOWN" "$REBOOT" "$SUSPEND" "$CANCEL" \
  | rofi -dmenu \
         -p "[ ⏻ POWER ]" \
         -theme ~/.config/rofi/themes/hacker.rasi \
         -lines 4 \
         -width 250)

case "$CHOICE" in
  "$SHUTDOWN") systemctl poweroff ;;
  "$REBOOT")   systemctl reboot ;;
  "$SUSPEND")  systemctl suspend ;;
esac
