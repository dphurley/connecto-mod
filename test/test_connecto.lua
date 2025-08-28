-- Test file for Connecto Mod
-- Run this to test basic functionality

local test = {}

function test.run_basic_tests()
  print("Running Connecto Mod basic tests...")
  
  -- Test mod loading
  local success, connecto = pcall(require, "mod")
  if success then
    print("✓ Mod loaded successfully")
  else
    print("✗ Mod failed to load: " .. tostring(connecto))
    return false
  end
  
  -- Test configuration loading
  local success, config = pcall(require, "config")
  if success then
    print("✓ Configuration loaded successfully")
    local default_sr = config.get("default_sample_rate")
    print("  Default sample rate: " .. tostring(default_sr))
  else
    print("✗ Configuration failed to load: " .. tostring(config))
  end
  
  -- Test audio interface library
  local success, audio_lib = pcall(require, "lib.audio_interface")
  if success then
    print("✓ Audio interface library loaded successfully")
    local caps = audio_lib.get_capabilities("test")
    print("  Supported sample rates: " .. table.concat(caps.sample_rates, ", "))
  else
    print("✗ Audio interface library failed to load: " .. tostring(audio_lib))
  end
  
  print("Basic tests completed")
  return true
end

-- Run tests if this file is executed directly
if arg and arg[0] and arg[0]:match("test_connecto.lua") then
  test.run_basic_tests()
end

return test
