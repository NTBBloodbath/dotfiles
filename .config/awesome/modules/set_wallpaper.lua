local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
end)
