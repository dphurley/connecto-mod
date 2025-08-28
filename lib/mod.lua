--
-- Connecto Mod for Norns
-- A mod for connecting to USB audio interfaces
-- Based on the original "connecto" script by totoetlititi
--

local mod = require('core/mods')
local util = require('util')

-- State variables
local state = {
  connected = false,
  connecting = false,
  input_device = "Default",
  output_device = "Default", 
  input_srate = "44100",
  output_srate = "44100",
  input_device_index = 0,
  output_device_index = 0,
  input_srate_index = 3,
  output_srate_index = 3,
  destination = 0 -- 0=device, 1=srate
}

-- Device lists
local array_of_inputs = {"Default"}
local array_of_outputs = {"Default"}
local array_of_srate = {"11025", "22050", "44100", "48000", "96000"}

-- Configuration file
local config_file = "connecto/last-config.data"

-- Utility function to find index in array
local function getindex(array, name)
  local result = -1
  for i,d in pairs(array) do
    if d == name then
      result = i
    end
  end
  return result
end

-- Parse device names from ALSA output
local function valid_device_name(devices_list)
  local devices = {}
  local raw_output = ""
  
  -- First, let's see what we're actually getting
  repeat
    local raw_list = devices_list:read("*l")
    if raw_list then
      raw_output = raw_output .. raw_list .. "\n"
      local words = {}
      for word in raw_list:gmatch("%S+") do 
        table.insert(words, word) 
      end
      
      -- More robust device detection
      if (words[1] == "card") then 
        if not (words[3] == "sndrpimonome" or words[3] == nil) then
          table.insert(devices, words[3])
        end
      end
      
      -- Alternative detection for USB devices
      if raw_list:match("USB") or raw_list:match("Audio") then
        local card_match = raw_list:match("card (%d+)")
        if card_match then
          local card_num = tonumber(card_match)
          if card_num and card_num > 0 then
            -- Try to get the device name from /proc/asound/card*/id
            local card_id_file = io.open("/proc/asound/card" .. card_num .. "/id", "r")
            if card_id_file then
              local card_id = card_id_file:read("*l")
              card_id_file:close()
              if card_id and card_id ~= "sndrpimonome" then
                -- Check if we already have this device
                local already_exists = false
                for _, existing in ipairs(devices) do
                  if existing == card_id then
                    already_exists = true
                    break
                  end
                end
                if not already_exists then
                  table.insert(devices, card_id)
                end
              end
            end
          end
        end
      end
    end
  until not raw_list
  
  -- Debug output
  print("Connecto Mod: Raw ALSA output:")
  print(raw_output)
  print("Connecto Mod: Parsed devices:", table.concat(devices, ", "))
  
  return devices
end

-- Refresh list of available audio devices
local function refresh_list_of_devices()
  local device_index = 0
  
  print("Connecto Mod: Starting device detection...")
  
  -- List all connected sound devices
  local get_inputs_list = io.popen('arecord -l 2>&1')
  local get_outputs_list = io.popen('aplay -l 2>&1')
  
  -- Also try alternative detection methods
  local alsa_cards = io.popen('cat /proc/asound/cards 2>&1')
  
  array_of_inputs = valid_device_name(get_inputs_list)
  array_of_outputs = valid_device_name(get_outputs_list)
  
  -- Alternative detection using /proc/asound/cards
  if alsa_cards then
    print("Connecto Mod: Checking /proc/asound/cards...")
    repeat
      local line = alsa_cards:read("*l")
      if line then
        print("Connecto Mod: Card line:", line)
        -- Look for USB audio devices
        if line:match("USB") or line:match("Audio") then
          local card_match = line:match("^%s*(%d+)")
          if card_match then
            local card_num = tonumber(card_match)
            if card_num and card_num > 0 then
              local card_id_file = io.open("/proc/asound/card" .. card_num .. "/id", "r")
              if card_id_file then
                local card_id = card_id_file:read("*l")
                card_id_file:close()
                if card_id and card_id ~= "sndrpimonome" then
                  -- Add to both input and output arrays if not already present
                  local function add_if_missing(device_array, device_name)
                    local exists = false
                    for _, existing in ipairs(device_array) do
                      if existing == device_name then
                        exists = true
                        break
                      end
                    end
                    if not exists then
                      table.insert(device_array, device_name)
                    end
                  end
                  
                  add_if_missing(array_of_inputs, card_id)
                  add_if_missing(array_of_outputs, card_id)
                end
              end
            end
          end
        end
      end
    until not line
    alsa_cards:close()
  end
  
  -- Always add Default as first option
  table.insert(array_of_inputs, 1, "Default")
  table.insert(array_of_outputs, 1, "Default")
  
  print("Connecto Mod: Final device lists:")
  for i=1, #array_of_inputs do
    print('Connecto Mod: Input Device: '..i..' > '..array_of_inputs[i])
  end
  for i=1, #array_of_outputs do
    print('Connecto Mod: Output Device: '..i..' > '..array_of_outputs[i])
  end
  
  -- Close the popen handles
  if get_inputs_list then get_inputs_list:close() end
  if get_outputs_list then get_outputs_list:close() end
end

-- Save configuration to file
local function save_config()
  print("Connecto Mod: _path.data: ".._path.data)
  local file = io.open(_path.data .. config_file, "w+")
  io.output(file)
  io.write("v1" .. "\n")
  io.write(state.input_device .. "\n")
  io.write(state.input_srate .. "\n")
  io.write(state.output_device .. "\n")
  io.write(state.output_srate .. "\n")
  io.close(file)
end

-- Load configuration from file
local function load_config()
  local file = io.open(_path.data .. config_file, "r")
  if file then
    print("Connecto Mod: datafile found")
    io.input(file)
    if io.read() == "v1" then
      local desired_input_device = io.read()
      local desired_input_srate = io.read()
      local desired_output_device = io.read()
      local desired_output_srate = io.read()
      
      -- Check if everything is fine
      local id = getindex(array_of_inputs, desired_input_device)
      if (id > -1) then 
        state.input_device_index = id
        state.input_device = array_of_inputs[state.input_device_index]
      end
      local id = getindex(array_of_outputs, desired_output_device)
      if (id > -1) then 
        state.output_device_index = id
        state.output_device = array_of_outputs[state.output_device_index]
      end
      local id = getindex(array_of_srate, desired_input_srate)
      if (id > -1) then 
        state.input_srate_index = id
        state.input_srate = array_of_srate[state.input_srate_index]
      end
      local id = getindex(array_of_srate, desired_output_srate)
      if (id > -1) then 
        state.output_srate_index = id
        state.output_srate = array_of_srate[state.output_srate_index]
      end
    end
    io.close(file)
  end
  
  print('Connecto Mod: Output: '..state.output_device_index..':'..state.output_device..' '..state.output_srate_index..':'..state.output_srate)
  print('Connecto Mod: Input: '..state.input_device_index..':'..state.input_device..' '..state.input_srate_index..':'..state.input_srate)
end

-- Create and run the connection script
local function connect()
  state.connecting = true
  mod.menu.redraw()
  
  -- Create the connection script
  local script_file = _path.temp .. "connecto_connect.sh"
  local script = io.open(script_file, "w")
  script:write("#!/bin/sh \n")
  script:write("killall alsa_in \n")
  script:write("killall alsa_out \n")
  script:write("sleep 1 \n")
  
  if not (state.input_device == "Default") then
    script:write("alsa_in -d hw:CARD=" .. state.input_device .." -r " .. state.input_srate .." & \n")
  end
  if not (state.output_device == "Default") then
    script:write("alsa_out -d hw:CARD=" .. state.output_device .." -r " .. state.output_srate .." & \n")
  end
  
  script:write("sleep 1 \n")
  
  if not (state.input_device == "Default") then
    script:write("jack_connect alsa_in:capture_1 softcut:input_1 \n")
    script:write("jack_connect alsa_in:capture_2 softcut:input_2 \n")
    script:write("jack_connect alsa_in:capture_1 crone:input_1 \n")
    script:write("jack_connect alsa_in:capture_2 crone:input_2 \n")
  end
  
  if not (state.output_device == "Default") then
    script:write("jack_connect crone:output_1 alsa_out:playback_1 \n")
    script:write("jack_connect crone:output_2 alsa_out:playback_2 \n")
  end
  
  script:close()
  
  -- Make executable and run
  os.execute("chmod +x " .. script_file)
  os.execute(script_file)
  
  state.connecting = false
  state.connected = true
  mod.menu.redraw()
end

-- Hook: called after matron has fully started
mod.hook.register("system_post_startup", "connecto startup", function()
  print("Connecto Mod: system startup complete")
  refresh_list_of_devices()
  load_config()
end)

-- Hook: called before a script's init() function
mod.hook.register("script_pre_init", "connecto pre-init", function()
  print("Connecto Mod: script pre-init")
  -- Auto-connect if enabled
  if state.connected then
    connect()
  end
end)

-- Hook: called after a script's init() function
mod.hook.register("script_post_init", "connecto post-init", function()
  print("Connecto Mod: script post-init")
end)

-- Hook: called after a script's cleanup() function
mod.hook.register("script_post_cleanup", "connecto cleanup", function()
  print("Connecto Mod: script cleanup")
end)

-- Menu: extending the menu system
local m = {}

m.key = function(n, z)
  if n == 1 and z == 1 then
    -- K1: Save config and connect
    save_config()
    connect()
  elseif n == 2 and z == 1 then
    -- K2: Test audio (play a note)
    if engine and engine.hz then
      engine.hz(440) -- A4 note
    end
  elseif n == 3 and z == 1 then
    -- K3: Toggle between device/srate selection
    state.destination = 1 - state.destination
    mod.menu.redraw()
  end
end

m.enc = function(n, d)
  if n == 1 then
    -- E1: Connect
    connect()
  elseif n == 2 then
    -- E2: Change input device/srate
    if (state.destination == 0) then -- device destination
      state.input_device_index = util.clamp(state.input_device_index + d, 1, #(array_of_inputs))
      state.input_device = array_of_inputs[state.input_device_index]
    else -- srate destination
      state.input_srate_index = util.clamp(state.input_srate_index + d, 1, #(array_of_srate))
      state.input_srate = array_of_srate[state.input_srate_index]
    end
  elseif n == 3 then
    -- E3: Change output device/srate
    if (state.destination == 0) then -- device destination
      state.output_device_index = util.clamp(state.output_device_index + d, 1, #(array_of_outputs))
      state.output_device = array_of_outputs[state.output_device_index]
    else -- srate destination
      state.output_srate_index = util.clamp(state.output_srate_index + d, 1, #(array_of_srate))
      state.output_srate = array_of_srate[state.output_srate_index]
    end
  end
  mod.menu.redraw()
end

-- Add a manual refresh function
local function manual_refresh()
  print("Connecto Mod: Manual refresh triggered")
  refresh_list_of_devices()
  -- Reset indices to safe values
  state.input_device_index = math.min(state.input_device_index, #array_of_inputs)
  state.output_device_index = math.min(state.output_device_index, #array_of_outputs)
  state.input_device = array_of_inputs[state.input_device_index] or "Default"
  state.output_device = array_of_outputs[state.output_device_index] or "Default"
  mod.menu.redraw()
end

-- Add refresh to the menu
m.refresh = manual_refresh

m.redraw = function()
  screen.clear()
  
  if state.connecting then
    -- Show connecting animation
    screen.level(15)
    screen.move(64, 32)
    screen.font_size(20)
    screen.text_center("CONNECTING...")
  else
    -- Show main interface
    local x1 = 5
    local x2 = 32
    local x3 = 96
    local y1 = 20
    local y2 = 30
    local y3 = 40
    local y4 = 50
    local y5 = 60
    local level_min = 3
    
    -- Draw labels
    screen.font_size(8)
    screen.level(level_min)
    screen.move(x2, y1)
    screen.text_center('INPUT')
    screen.move(x3, y1)
    screen.text_center('OUTPUT')
    
    -- Draw device names
    if (state.destination == 0) then 
      screen.level(15) 
    else 
      screen.level(level_min) 
    end
    screen.move(x2, y2)
    screen.text_center(state.input_device)
    screen.move(x3, y2)
    screen.text_center(state.output_device)
    
    -- Draw sample rates
    if (state.destination == 1) then 
      screen.level(15) 
    else 
      screen.level(level_min) 
    end
    screen.move(x2, y3)
    screen.text_center(state.input_srate..'Hz')
    screen.move(x3, y3)
    screen.text_center(state.output_srate..'Hz')
    
    -- Draw connection status
    screen.level(1)
    screen.move(64, y4)
    if state.connected then
      screen.text_center("CONNECTED")
    else
      screen.text_center("Press K1 to connect")
    end
    
    -- Draw debug info
    screen.level(2)
    screen.font_size(6)
    screen.move(64, y5)
    screen.text_center("Devices: " .. #array_of_inputs .. " input, " .. #array_of_outputs .. " output")
    
    -- Draw frame
    screen.level(8)
    screen.rect(1, 1, 126, 62)
    screen.stroke()
  end
  
  screen.update()
end

m.init = function()
  -- Menu initialization
  print("Connecto Mod: menu initialized")
end

m.deinit = function()
  -- Menu cleanup
  print("Connecto Mod: menu deinitialized")
end

-- Register the menu with a specific name
mod.menu.register("connecto", m)

-- Return the mod table
return mod
