-- Connecto Mod Configuration
-- User-configurable settings for the mod

local config = {}

-- Default configuration values
config.defaults = {
  -- Audio settings
  default_sample_rate = 48000,
  default_channels = 2,
  auto_connect = false,
  
  -- Interface preferences
  preferred_interfaces = {
    "Focusrite Scarlett",
    "Behringer U-Phoria",
    "Native Instruments"
  },
  
  -- Connection settings
  connection_timeout = 5000, -- milliseconds
  retry_attempts = 3,
  
  -- UI settings
  show_advanced_options = false,
  auto_scan_on_startup = true
}

-- Load configuration from file
function config.load()
  -- TODO: Implement configuration loading from file
  -- This would typically load from a JSON or Lua file
  print("Configuration loading not yet implemented")
  return config.defaults
end

-- Save configuration to file
function config.save(settings)
  -- TODO: Implement configuration saving to file
  print("Configuration saving not yet implemented")
end

-- Get a configuration value
function config.get(key)
  local settings = config.load()
  return settings[key] or config.defaults[key]
end

-- Set a configuration value
function config.set(key, value)
  local settings = config.load()
  settings[key] = value
  config.save(settings)
end

-- Reset to default configuration
function config.reset()
  config.save(config.defaults)
end

return config
