#!/bin/sh

set -eu

REPO_URL='https://github.com/andre-kotake/dotfiles.git'
INSTALL_DIR="${1:-dotfiles}"

if ! command -v git >/dev/null 2>&1; then
  printf '%s\n' 'Error: git is required but was not found.' >&2
  exit 1
fi

if [ -e "$INSTALL_DIR" ]; then
  printf 'Error: destination already exists: %s\n' "$INSTALL_DIR" >&2
  exit 1
fi

printf '%s\n' 'Cloning dotfiles...'
git clone "$REPO_URL" "$INSTALL_DIR"

printf '%s\n' 'Running installer...'
cd "$INSTALL_DIR"

if [ ! -f ./lib/install.sh ]; then
  printf '%s\n' 'Error: install.sh was not found in the repository root.' >&2
  exit 1
fi

sh ./lib/install.sh

printf '%s\n' 'Installation completed successfully.'
