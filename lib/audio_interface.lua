--
-- Audio Interface Library for Connecto Mod
-- Provides utilities for detecting and managing USB audio interfaces
--

local audio_interface = {}

-- Get list of available audio input devices
function audio_interface.get_input_devices()
  local devices = {}
  local get_inputs_list = io.popen('arecord -l')
  if get_inputs_list then
    repeat
      local raw_list = get_inputs_list:read("*l")
      if raw_list then
        local words = {}
        for word in raw_list:gmatch("%S+") do 
          table.insert(words, word) 
        end
        if (words[1] == "card") then 
          if not (words[3] == "sndrpimonome" or words[3] == nil) then
            table.insert(devices, words[3])
          end
        end
      end
    until not raw_list
    get_inputs_list:close()
  end
  return devices
end

-- Get list of available audio output devices
function audio_interface.get_output_devices()
  local devices = {}
  local get_outputs_list = io.popen('aplay -l')
  if get_outputs_list then
    repeat
      local raw_list = get_outputs_list:read("*l")
      if raw_list then
        local words = {}
        for word in raw_list:gmatch("%S+") do 
          table.insert(words, word) 
        end
        if (words[1] == "card") then 
          if not (words[3] == "sndrpimonome" or words[3] == nil) then
            table.insert(devices, words[3])
          end
        end
      end
    until not raw_list
    get_outputs_list:close()
  end
  return devices
end

-- Check if a specific device is available
function audio_interface.device_exists(device_name, device_type)
  local devices = {}
  if device_type == "input" then
    devices = audio_interface.get_input_devices()
  elseif device_type == "output" then
    devices = audio_interface.get_output_devices()
  else
    return false
  end
  
  for _, device in ipairs(devices) do
    if device == device_name then
      return true
    end
  end
  return false
end

-- Get device capabilities (sample rates, channels)
function audio_interface.get_device_capabilities(device_name)
  local capabilities = {
    sample_rates = {},
    channels = 2,
    available = false
  }
  
  -- Check if device exists
  if not (audio_interface.device_exists(device_name, "input") or 
          audio_interface.device_exists(device_name, "output")) then
    return capabilities
  end
  
  capabilities.available = true
  
  -- Get sample rate support
  local cmd = string.format("cat /proc/asound/%s/pcm*/sub*/hw_params 2>/dev/null | grep -o '[0-9]* Hz' | sort -u", device_name)
  local handle = io.popen(cmd)
  if handle then
    repeat
      local line = handle:read("*l")
      if line then
        local rate = line:match("([0-9]+) Hz")
        if rate then
          table.insert(capabilities.sample_rates, tonumber(rate))
        end
      end
    until not line
    handle:close()
  end
  
  -- Sort sample rates
  table.sort(capabilities.sample_rates)
  
  return capabilities
end

-- Validate device configuration
function audio_interface.validate_config(input_device, output_device, input_srate, output_srate)
  local errors = {}
  
  -- Check input device
  if input_device ~= "Default" and not audio_interface.device_exists(input_device, "input") then
    table.insert(errors, "Input device '" .. input_device .. "' not found")
  end
  
  -- Check output device
  if output_device ~= "Default" and not audio_interface.device_exists(output_device, "output") then
    table.insert(errors, "Output device '" .. output_device .. "' not found")
  end
  
  -- Check sample rates
  local valid_rates = {"11025", "22050", "44100", "48000", "96000"}
  local input_valid = false
  local output_valid = false
  
  for _, rate in ipairs(valid_rates) do
    if rate == input_srate then input_valid = true end
    if rate == output_srate then output_valid = true end
  end
  
  if not input_valid then
    table.insert(errors, "Invalid input sample rate: " .. input_srate)
  end
  
  if not output_valid then
    table.insert(errors, "Invalid output sample rate: " .. output_srate)
  end
  
  return #errors == 0, errors
end

-- Get connection status
function audio_interface.get_connection_status()
  local status = {
    alsa_in_running = false,
    alsa_out_running = false,
    jack_connections = {}
  }
  
  -- Check if alsa_in is running
  local alsa_in_check = io.popen("pgrep alsa_in")
  if alsa_in_check then
    status.alsa_in_running = alsa_in_check:read("*l") ~= nil
    alsa_in_check:close()
  end
  
  -- Check if alsa_out is running
  local alsa_out_check = io.popen("pgrep alsa_out")
  if alsa_out_check then
    status.alsa_out_running = alsa_out_check:read("*l") ~= nil
    alsa_out_check:close()
  end
  
  -- Check jack connections
  local jack_check = io.popen("jack_lsp -c 2>/dev/null")
  if jack_check then
    repeat
      local line = jack_check:read("*l")
      if line then
        if line:match("alsa_in:") or line:match("alsa_out:") then
          table.insert(status.jack_connections, line)
        end
      end
    until not line
    jack_check:close()
  end
  
  return status
end

-- Test audio connection
function audio_interface.test_connection()
  local status = audio_interface.get_connection_status()
  local test_result = {
    success = false,
    message = "",
    details = status
  }
  
  if not status.alsa_in_running and not status.alsa_out_running then
    test_result.message = "No audio devices connected"
    return test_result
  end
  
  if #status.jack_connections == 0 then
    test_result.message = "Audio devices running but no JACK connections"
    return test_result
  end
  
  test_result.success = true
  test_result.message = "Audio connection active"
  return test_result
end

return audio_interface
