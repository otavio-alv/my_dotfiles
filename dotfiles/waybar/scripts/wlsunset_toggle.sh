#!/bin/bash
# ── backlight-toggle.sh ──────────────────────────────────────────────────────
# Toggle wlsunset (Blue light filter) on/off.
# Usage: Waybar `custom/backlight` module :on-click
# Output: (changes state only)
# ───────────────────────────────────────────────────────────────────────────── 

WS_BIN="wlsunset"
PIDFILE="$HOME/.wlsunset.pid"

start_wlsunset() {
    $WS_BIN -l 20.0 -L -40.0 -t 4000 -T 6500 -d 10 &
    echo $! > "$PIDFILE"
}

stop_wlsunset() {
    if [ -f "$PIDFILE" ]; then
        kill $(cat "$PIDFILE") 2>/dev/null || true
        rm -f "$PIDFILE"
    fi
    killall "$WS_BIN" 2>/dev/null || true
}

if pgrep -x "$WS_BIN" > /dev/null; then
    stop_wlsunset
else
    start_wlsunset
fi