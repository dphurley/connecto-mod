# Connecto Mod

A Norns mod for connecting to USB audio interfaces, converted from the original connecto script.

## Description

Connecto Mod allows your Norns device to connect to USB audio interfaces, providing:
- Automatic USB audio interface detection
- Easy connection management
- Configurable audio settings (sample rate, channels)
- Support for common USB audio interfaces

## Installation

### Method 1: Using the Installation Script (Recommended)
1. Clone this repository to your Norns device:
   ```bash
   cd ~/dust/code
   git clone https://github.com/dphurley/connecto-mod.git
   ```

2. Run the installation script:
   ```bash
   cd connecto-mod
   ./install.sh
   ```

3. Restart your Norns (SYSTEM → RESTART)

### Method 2: Manual Installation
1. Clone this repository to your Norns device:
   ```bash
   cd ~/dust/code
   git clone https://github.com/dphurley/connecto-mod.git
   ```

2. Copy the mod files to the correct location:
   ```bash
   mkdir -p ~/dust/mods/connecto
   cp -r connecto-mod/lib ~/dust/mods/connecto/
   cp connecto-mod/config.lua ~/dust/mods/connecto/
   ```

3. Restart your Norns (SYSTEM → RESTART)

### Method 3: Using Norns Community Mods
*Coming soon - this mod will be available through the Norns Community Mods system*

## Mod Structure

This mod follows the official Monome mod structure:
```
~/dust/mods/connecto/
├── lib/
│   └── mod.lua          # Main mod file (REQUIRED)
└── config.lua            # Configuration file
```

## Usage

### Enabling the Mod
1. Install the mod on your Norns device
2. Restart your Norns (SYSTEM → RESTART)
3. Go to SYSTEM → MODS
4. Find "connecto" in the list and enable it using E2/E3
5. Restart again to activate the mod

### Basic Usage
Once enabled, the mod will:
- Automatically scan for available USB audio interfaces
- Provide hooks for script initialization and cleanup
- Offer a menu interface accessible via SYSTEM → MODS

### Supported Interfaces
The mod is designed to work with common USB audio interfaces including:
- Focusrite Scarlett series
- Behringer U-Phoria series
- Native Instruments audio interfaces
- RME USB interfaces
- Universal Audio interfaces
- Apogee USB interfaces
- Motu USB interfaces

### Configuration
The mod can be configured through the `config.lua` file or through the mod's interface:
- Default sample rate and channel count
- Preferred interface list
- Auto-connection settings
- Connection timeout and retry settings

## Development Status

⚠️ **Work in Progress** ⚠️

This mod is currently under development. The following features are planned:
- [ ] USB audio interface detection implementation
- [ ] ALSA integration for audio routing
- [ ] User interface for connection management
- [ ] Configuration persistence
- [ ] Error handling and recovery
- [ ] Testing with various USB audio interfaces

## Contributing

Contributions are welcome! This mod is designed to be modular and extensible. Areas that need work include:
- Audio interface detection logic
- ALSA integration
- User interface development
- Testing with different hardware

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Based on the original "connecto" Norns script
- Built for the Norns platform by Monome
- Community-driven development

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check the Norns community forums
- Join the Norns Discord server
