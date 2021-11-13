-- Run all the apps listed in configuration

local awful = require("awful")
local autostart = require("configuration.autostart")

local function run_once(cmd)
  local running_process = cmd
  local first_space = cmd:find(" ")
  if first_space then
    running_process = cmd:sub(0, first_space - 1)
  end

  awful.spawn.with_shell(
    string.format("pgrep -u $USER -x %s > /dev/null || (%s)", running_process, cmd)
  )
end

for _, process in ipairs(autostart.run_on_start_up) do
  run_once(process)
end
