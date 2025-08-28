#!/bin/bash

# Quick Install Script for Connecto Mod
# Run this from anywhere to install the mod

echo "🎵 Quick Install: Connecto Mod for Norns"
echo "========================================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📁 Script location: $SCRIPT_DIR"

# Check if connecto directory exists
if [ ! -d "$SCRIPT_DIR/connecto" ]; then
    echo "❌ Error: connecto directory not found!"
    echo "Make sure you're running this from the connecto-mod repository root"
    exit 1
fi

# Navigate to Norns mods directory (not code directory)
echo "📂 Installing to ~/dust/mods/connecto..."
cd ~/dust/mods

# Remove existing mod if it exists
if [ -d "connecto" ]; then
    echo "⚠️  Removing existing connecto mod..."
    rm -rf connecto
fi

# Copy the mod
echo "📋 Copying mod files..."
cp -r "$SCRIPT_DIR/connecto" .

# Set permissions
echo "🔐 Setting permissions..."
chmod -R 755 connecto

echo ""
echo "✅ Connecto Mod installed successfully!"
echo ""
echo "Next steps:"
echo "1. Restart your Norns (SYSTEM → RESTART)"
echo "2. The mod will be available in your mod system"
echo ""
echo "Mod location: ~/dust/mods/connecto"
echo ""
echo "Note: Norns mods go in ~/dust/mods/, not ~/dust/code/"
