#!/bin/sh
set -e

# Determine the system architecture
ARCH=$(uname -m)
MITAMAE_BIN="./mitamae"

if [[ "$ARCH" == "arm64" ]]; then
	ARCH="aarch64"
fi

# Download mitamae for x86_64 or aarch64 based on the system architecture
if [[ ! -f "$MITAMAE_BIN" ]]; then
  curl -LO "https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-$ARCH-darwin.tar.gz"
  tar xzf mitamae-$ARCH-darwin.tar.gz
  rm mitamae-$ARCH-darwin.tar.gz
	mv mitamae-$ARCH-darwin $MITAMAE_BIN
fi

$MITAMAE_BIN version
$MITAMAE_BIN local $@ files/recipe.rb
