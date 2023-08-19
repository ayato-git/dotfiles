#!/bin/sh
set -e

# Determine the system architecture
ARCH=$(uname -m)
MITAMAE_PATH="/usr/local/bin/mitamae"

# Download mitamae for x86_64 or aarch64 based on the system architecture
if [[ ! -f "$MITAMAE_PATH" ]]; then
  curl -LO "https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-$ARCH-darwin.tar.gz"
  tar xzf mitamae-$ARCH-darwin.tar.gz
  rm mitamae-$ARCH-darwin.tar.gz
  mv mitamae* "$MITAMAE_PATH"
fi

"$MITAMAE_PATH" version
"$MITAMAE_PATH" local $@ files/recipe.rb
