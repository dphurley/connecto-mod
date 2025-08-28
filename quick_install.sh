#!/bin/bash

# Quick Install Script for Connecto Mod
# This script installs the Connecto mod on your Norns device

echo "=== Connecto Mod Installation ==="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create the mod directory in ~/dust/code/ (not ~/dust/mods/)
MOD_DIR="$HOME/dust/code/connecto"

echo "Installing to: $MOD_DIR"
echo ""

# Create the mod directory
mkdir -p "$MOD_DIR"

# Copy the lib directory (which contains mod.lua)
echo "Copying mod files..."
cp -r "$SCRIPT_DIR/lib" "$MOD_DIR/"

# Copy the audio interface library
cp -r "$SCRIPT_DIR/lib/audio_interface.lua" "$MOD_DIR/lib/"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Mod Structure:"
echo "  ~/dust/code/connecto/"
echo "  └── lib/"
echo "      ├── mod.lua"
echo "      └── audio_interface.lua"
echo ""
echo "Next steps:"
echo "1. Restart your Norns (SYSTEM > RESTART)"
echo "2. Go to SYSTEM > MODS to see the connecto mod"
echo "3. Use E2 to select it, then E3 to enable it"
echo "4. Restart again to activate the mod"
echo ""
echo "The mod will be available to all scripts once enabled."
