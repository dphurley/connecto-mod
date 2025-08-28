#!/bin/bash

# Quick Install Script for Connecto Mod
# Run this from anywhere to install the mod

echo "🎵 Quick Install: Connecto Mod for Norns"
echo "========================================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Script location: $SCRIPT_DIR"

# Navigate to Norns mods directory
echo "📂 Installing to ~/dust/mods/connecto..."
cd ~/dust/mods

# Remove existing mod if it exists
if [ -d "connecto" ]; then
    echo "⚠️  Removing existing connecto mod..."
    rm -rf connecto
fi

# Create mod directory
mkdir connecto

# Copy the mod files to the correct structure
echo "📋 Copying mod files..."
cp -r "$SCRIPT_DIR/lib" connecto/
cp "$SCRIPT_DIR/config.lua" connecto/

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 755 connecto

echo ""
echo "✅ Connecto Mod installed successfully!"
echo ""
echo "Mod structure:"
echo "~/dust/mods/connecto/"
echo "├── lib/"
echo "│   └── mod.lua          # Main mod file (REQUIRED)"
echo "└── config.lua"
echo ""
echo "Next steps:"
echo "1. Restart your Norns (SYSTEM → RESTART)"
echo "2. Go to SYSTEM → MODS to enable the mod"
echo "3. The mod will be available in your mod system"
