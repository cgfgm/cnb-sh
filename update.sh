#!/usr/bin/env bash

set -euo pipefail

PACKAGES=(
  curl
  wget
  git
  vim
  htop
  net-tools
  python3
  python3-openssl
  python3-cryptography
  libncursesw6
  ncurses-term
  bash
  locales
  git-lfs
  ccache
  xclip
  wl-clipboard
  libfreetype6
  fontconfig
  unzip
  zip
  fzf
)

echo "Updating package lists..."
apt-get update

echo "Upgrading installed packages..."
if ! apt-get upgrade -y; then
  echo "Warning: apt-get upgrade failed; continuing with the remaining steps." >&2
fi

echo "Installing required packages..."
apt-get install -y "${PACKAGES[@]}"

echo "Verifying package installation..."
missing_packages=()
for package in "${PACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "$package" 2>/dev/null \
    | grep -q '^install ok installed$'; then
    printf '  [OK]     %s\n' "$package"
  else
    printf '  [MISSING] %s\n' "$package"
    missing_packages+=("$package")
  fi
done

if ((${#missing_packages[@]} > 0)); then
  printf 'Package installation verification failed: %s\n' \
    "${missing_packages[*]}" >&2
  exit 1
fi

mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"

echo "Installing repo..."
curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo \
  -o "$HOME/bin/repo"
chmod a+x "$HOME/bin/repo"

echo "All packages and tools were installed successfully."