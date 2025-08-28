#!/bin/bash

# Connecto Mod Installation Script for Norns
# This script helps install the connecto mod on your Norns device

echo "🎵 Connecto Mod Installation for Norns"
echo "======================================"

# Check if we're on Norns
if [[ "$(hostname)" == "norns" ]]; then
    echo "✓ Running on Norns device"
    
    # Navigate to the correct directory
    cd ~/dust/code
    
    # Check if mod already exists
    if [ -d "connecto" ]; then
        echo "⚠️  Mod directory already exists. Updating..."
        rm -rf connecto
    fi
    
    # Copy the mod files
    echo "📁 Installing mod files..."
    cp -r connecto ~/dust/code/
    
    # Set proper permissions
    chmod -R 755 ~/dust/code/connecto
    
    echo "✅ Mod installed successfully!"
    echo ""
    echo "To use the mod:"
    echo "1. Restart your Norns (SYSTEM → RESTART)"
    echo "2. The mod will be available in your mod system"
    echo "3. Check the README.md for usage instructions"
    
else
    echo "❌ This script should be run on your Norns device"
    echo ""
    echo "To install manually:"
    echo "1. SSH into your Norns: ssh norns@[IP_ADDRESS]"
    echo "2. Navigate to: cd ~/dust/code"
    echo "3. Copy the 'connecto' folder to that location"
    echo "4. Restart your Norns"
fi
