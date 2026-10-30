#!/bin/bash

WS_BIN="wlsunset"

if pgrep -x "$WS_BIN" > /dev/null; then
    WLS="ON"
    WLS_CLASS="wlsunset-on"
else
    WLS="OFF"
    WLS_CLASS="wlsunset-off"
fi

if command -v brightnessctl >/dev/null 2>&1; then
    PERCENT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
else
    PERCENT=""
fi

if [ -z "$PERCENT" ]; then
    PERCENT=0
fi

if [ "$PERCENT" -le 11 ]; then
    ICON=""
elif [ "$PERCENT" -le 22 ]; then
    ICON=""
elif [ "$PERCENT" -le 33 ]; then
    ICON=""
elif [ "$PERCENT" -le 44 ]; then
    ICON=""
elif [ "$PERCENT" -le 55 ]; then
    ICON=""
elif [ "$PERCENT" -le 66 ]; then
    ICON=""
elif [ "$PERCENT" -le 77 ]; then
    ICON=""
elif [ "$PERCENT" -le 88 ]; then
    ICON=""
else
    ICON=""
fi

TEXT="[ $ICON  ${PERCENT}% ]"
TOOLTIP="Luz noturna: $WLS | Brilho: ${PERCENT}%"

printf '{"text":"%s","tooltip":"%s","class":"%s","percentage":%s}\n' \
  "$TEXT" "$TOOLTIP" "$WLS_CLASS" "$PERCENT"