# Connecto Mod for Norns

A Norns mod that enables connection to USB audio interfaces, allowing you to use external audio hardware with your Norns device.

## What It Does

The Connecto Mod automatically detects and connects to USB audio interfaces when scripts start up, providing seamless integration with external audio hardware. It handles:

- USB audio interface detection
- Automatic connection management
- Audio routing configuration
- Interface status monitoring

## Installation

### Quick Install (Recommended)

1. **Clone the repository on your Norns:**
   ```bash
   cd ~/dust/code
   git clone https://github.com/dphurley/connecto-mod.git
   cd connecto-mod
   ```

2. **Run the installation script:**
   ```bash
   ./quick_install.sh
   ```

3. **Restart your Norns:**
   - Go to `SYSTEM > RESTART`
   - Wait for the system to fully restart

4. **Enable the mod:**
   - Go to `SYSTEM > MODS`
   - Find "connecto" in the list
   - Use `E2` to select it, then `E3` to enable it
   - Restart again to activate the mod

### Manual Installation

If you prefer to install manually:

1. **Create the mod directory:**
   ```bash
   mkdir -p ~/dust/code/connecto
   ```

2. **Copy the mod files:**
   ```bash
   cp -r lib ~/dust/code/connecto/
   ```

3. **Follow steps 3-4 from Quick Install above**

## Mod Structure

The mod follows the official Norns mod structure:

```
~/dust/code/connecto/
└── lib/
    ├── mod.lua              # Main mod file (REQUIRED)
    └── audio_interface.lua  # Audio interface management
```

## Usage

Once installed and enabled, the Connecto Mod will:

- Automatically scan for USB audio interfaces on system startup
- Connect to available interfaces when scripts initialize
- Provide audio routing capabilities to all scripts
- Handle interface disconnection and reconnection

## Supported Interfaces

The mod is designed to work with standard USB audio interfaces including:

- Focusrite Scarlett series
- Behringer U-Phoria series
- Native Instruments Audio interfaces
- Generic USB audio devices
- Class-compliant USB audio interfaces

## Configuration

The mod can be configured through the `SYSTEM > MODS` menu:

- **E2**: Navigate through options
- **E3**: Select/confirm options
- **K3**: Enter the mod's menu (if available)

## Development Status

🚧 **Work in Progress**

This mod is currently under development. Planned features include:

- [x] Basic mod structure and hooks
- [x] USB audio interface detection framework
- [x] Installation scripts
- [ ] ALSA integration for interface detection
- [ ] Audio routing implementation
- [ ] Interface configuration options
- [ ] Status monitoring and display

## Contributing

Contributions are welcome! This mod is designed to be:

- **Modular**: Easy to extend with new features
- **Compatible**: Works with existing Norns scripts
- **Reliable**: Stable operation across different hardware

To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on Norns hardware
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Monome team for the Norns platform and mod system
- Norns community for testing and feedback
- Original Connecto script developers for the concept

## Support

For issues or questions:
- Check the [Issues](https://github.com/dphurley/connecto-mod/issues) page
- Review the [Roadmap](ROADMAP.md) for development plans
- Consult the Norns documentation for mod development
