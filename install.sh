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
    
    # Copy the mod files from the script directory
    echo "📁 Installing mod files..."
    if [ -d "$SCRIPT_DIR/connecto" ]; then
        cp -r "$SCRIPT_DIR/connecto" .
        echo "✓ Mod files copied successfully"
    else
        echo "❌ Error: connecto directory not found in $SCRIPT_DIR"
        echo "Current directory contents:"
        ls -la "$SCRIPT_DIR"
        exit 1
    fi
    
    # Set proper permissions
    chmod -R 755 connecto
    
    echo "✅ Mod installed successfully!"
    echo ""
    echo "To use the mod:"
    echo "1. Restart your Norns (SYSTEM → RESTART)"
    echo "2. The mod will be available in your mod system"
    echo "3. Check the README.md for usage instructions"
    echo ""
    echo "Note: Norns mods go in ~/dust/mods/, not ~/dust/code/"
    
else
    echo "❌ This script should be run on your Norns device"
    echo ""
    echo "To install manually:"
    echo "1. SSH into your Norns: ssh norns@[IP_ADDRESS]"
    echo "2. Navigate to: cd ~/dust/mods"
    echo "3. Copy the 'connecto' folder to that location"
    echo "4. Restart your Norns"
fi
