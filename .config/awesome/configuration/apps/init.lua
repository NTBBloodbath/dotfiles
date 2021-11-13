local menubar = require("menubar")

local apps = {
  -- Your default terminal
  terminal = "kitty",

  -- Your default text editor
  editor = os.getenv("EDITOR") or "nvim",

  -- Your default file explorer
  explorer = "xplr",
}

apps.editor_cmd = apps.terminal .. " -e " .. apps.editor
apps.explorer_cmd = apps.terminal .. " -e " .. apps.explorer
menubar.utils.terminal = apps.terminal -- Set the terminal for applications that require it

return apps
