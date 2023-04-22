#!/bin/bash

# Determine the system architecture
ARCH=$(uname -m)

# Set the default installation directory
if [[ "$ARCH" == "x86_64" ]]; then
    # For x86_64 systems, use the standard /usr/local/bin directory
    MITAMAE_PATH="/usr/local/bin/mitamae"
else
    # For Apple Silicon (aarch64) systems, use the /opt/homebrew/bin directory
    # which is the default installation path for Homebrew on M1 Macs
    MITAMAE_PATH="/opt/homebrew/bin/mitamae"
fi

# Download mitamae for x86_64 or aarch64 based on the system architecture
if [[ ! -f "$MITAMAE_PATH" ]]; then
  curl -LO "https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-$ARCH-darwin.tar.gz"
  tar xzf mitamae-$ARCH-darwin.tar.gz
  rm mitamae-$ARCH-darwin.tar.gz
  mv mitamae* "$MITAMAE_PATH"
fi

