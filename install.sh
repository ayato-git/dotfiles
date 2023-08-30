#!/bin/sh
set -e

# Determine the system architecture
ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
	ARCH="aarch64"
fi

# Download mitamae for x86_64 or aarch64 based on the system architecture
if [[ ! -f "$MITAMAE_PATH" ]]; then
  curl -LO "https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-$ARCH-darwin.tar.gz"
  tar xzf mitamae-$ARCH-darwin.tar.gz
  rm mitamae-$ARCH-darwin.tar.gz
fi

./mitamae-$ARCH-darwin version
./mitamae-$ARCH-darwin local $@ files/recipe.rb
