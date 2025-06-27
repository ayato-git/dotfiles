#!/bin/sh
set -e

# OS detection
OS="$(uname -s)"
ARCH="$(uname -m)"
MITAMAE_BIN="./mitamae"

# Convert architecture names for mitamae compatibility
if [ "$ARCH" = "arm64" ]; then
    ARCH="aarch64"
fi

# Determine OS-specific settings
case "$OS" in
    "Darwin")
        OS_NAME="macos"
        MITAMAE_OS="darwin"
        RECIPE_FILE="files/recipe-macos.rb"
        ;;
    "Linux")
        OS_NAME="linux"
        MITAMAE_OS="linux"
        RECIPE_FILE="files/recipe-linux.rb"
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

echo "Detected OS: $OS_NAME ($OS) on $ARCH"

# Download mitamae binary if not exists
if [ ! -f "$MITAMAE_BIN" ]; then
    echo "Downloading mitamae binary for $OS_NAME..."
    MITAMAE_URL="https://github.com/itamae-kitchen/mitamae/releases/latest/download/mitamae-$ARCH-$MITAMAE_OS.tar.gz"

    if command -v curl >/dev/null 2>&1; then
        curl -LO "$MITAMAE_URL"
    elif command -v wget >/dev/null 2>&1; then
        wget "$MITAMAE_URL"
    else
        echo "Error: curl or wget is required to download mitamae"
        exit 1
    fi

    tar xzf "mitamae-$ARCH-$MITAMAE_OS.tar.gz"
    rm "mitamae-$ARCH-$MITAMAE_OS.tar.gz"
    mv "mitamae-$ARCH-$MITAMAE_OS" "$MITAMAE_BIN"
    chmod +x "$MITAMAE_BIN"
fi

# Show mitamae version
$MITAMAE_BIN version

# Run OS-specific recipe
echo "Running $RECIPE_FILE..."
$MITAMAE_BIN local "$@" "$RECIPE_FILE"
