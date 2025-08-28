#!/bin/bash

# Connecto Mod Installation Script for Norns
# This script helps install the connecto mod on your Norns device

echo "🎵 Connecto Mod Installation for Norns"
echo "======================================"

# Check if we're on Norns
if [[ "$(hostname)" == "norns" ]]; then
    echo "✓ Running on Norns device"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Navigate to the correct directory (mods, not code)
    cd ~/dust/mods
    
    # Check if mod already exists
    if [ -d "connecto" ]; then
        echo "⚠️  Mod directory already exists. Updating..."
        rm -rf connecto
    fi
    
    # Create mod directory and copy files
    echo "📁 Installing mod files..."
    mkdir connecto
    cp -r "$SCRIPT_DIR/lib" connecto/
    cp "$SCRIPT_DIR/config.lua" connecto/
    
    echo "✓ Mod files copied successfully"
    
    # Set proper permissions
    chmod -R 755 connecto
    
    echo "✅ Mod installed successfully!"
    echo ""
    echo "Mod structure:"
    echo "~/dust/mods/connecto/"
    echo "├── lib/"
    echo "│   └── mod.lua          # Main mod file (REQUIRED)"
    echo "└── config.lua"
    echo ""
    echo "To use the mod:"
    echo "1. Restart your Norns (SYSTEM → RESTART)"
    echo "2. Go to SYSTEM → MODS to enable the mod"
    echo "3. The mod will be available in your mod system"
    echo "4. Check the README.md for usage instructions"
    
else
    echo "❌ This script should be run on your Norns device"
    echo ""
    echo "To install manually:"
    echo "1. SSH into your Norns: ssh norns@[IP_ADDRESS]"
    echo "2. Navigate to: cd ~/dust/mods"
    echo "3. Create connecto directory and copy lib/mod.lua"
    echo "4. Restart your Norns"
fi
