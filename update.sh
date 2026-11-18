#!/usr/bin/env bash
# Copies the current configs from ~/.config into this repository.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${XDG_CONFIG_HOME:-$HOME/.config}"
DEST="$REPO/dotfiles"

DIRS=(kitty rofi sway swaylock systemd theme waybar fastfetch)

sync_dir() { # source destination
  mkdir -p "$2"
  if command -v rsync >/dev/null; then
    rsync -a --delete "$1/" "$2/"
  else
    rm -rf "$2"; mkdir -p "$2"; cp -a "$1/." "$2/"
  fi
}

for d in "${DIRS[@]}"; do
  if [[ -d "$SRC/$d" ]]; then
    echo "-> $d"
    sync_dir "$SRC/$d" "$DEST/$d"
  else
    echo "!! $SRC/$d does not exist, skipping" >&2
  fi
done

if [[ -d "$SRC/xkb/symbols" ]]; then
  echo "-> xkb"
  mkdir -p "$REPO/xkb"
  cp -a "$SRC/xkb/symbols/." "$REPO/xkb/"
else
  echo "!! $SRC/xkb/symbols does not exist, skipping" >&2
fi

# Privacy: replace the real home path with a placeholder in the repo copies
# (the live configs in ~/.config are left untouched).
grep -rIl --exclude-dir=.git "$HOME" "$REPO/dotfiles" "$REPO/xkb" 2>/dev/null \
  | xargs -r sed -i "s|$HOME|/home/USER|g"

# Same for absolute symlinks that point into $HOME
while IFS= read -r -d '' l; do
  t="$(readlink "$l")"
  [[ "$t" == "$HOME"* ]] && ln -sfn "/home/USER${t#"$HOME"}" "$l"
done < <(find "$REPO/dotfiles" -type l -print0)

echo "Done."
