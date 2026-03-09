#!/usr/bin/env bash
set -euo pipefail

read -r -d '' packages <<EOF || true
htop
vim
wget
git
zsh
EOF

pacman -Qq \
  | awk 'NR==FNR {installed[$1]; next} !($1 in installed)' - \
    <(printf '%s\n' "$packages")
