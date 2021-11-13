local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local hotkeys_popup = require("awful.hotkeys_popup").widget

local modkey = require("configuration.keybinds.mod").modKey
local altkey = require("configuration.keybinds.mod").altKey
local apps = require("configuration.apps")

local audio_sink = "alsa_output.pci-0000_00_1b.0.analog-stereo"
local globalkeys = gears.table.join(
  -- Volume control
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn.with_shell("pactl set-sink-volume " .. audio_sink .. " +5%")
  end, {
    description = "Volume up",
    group = "volume",
  }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn.with_shell("pactl set-sink-volume " .. audio_sink .. " -5%")
  end, {
    description = "Volume down",
    group = "volume",
  }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn.with_shell("amixer sset Master toggle")
  end, {
    description = "Mute volume",
    group = "volume",
  }),
  awful.key({}, "XF86AudioPlay", function()
    awful.spawn.with_shell("playerctl play-pause")
  end, {
    description = "Resume song",
    group = "volume",
  }),
  awful.key({}, "XF86AudioPrev", function()
    awful.spawn.with_shell("playerctl previous")
  end, {
    description = "Prev song",
    group = "volume",
  }),
  awful.key({}, "XF86AudioNext", function()
    awful.spawn.with_shell("playerctl next")
  end, {
    description = "Next song",
    group = "volume",
  }),
  awful.key({}, "XF86AudioStop", function()
    awful.spawn.with_shell("playerctl stop")
  end, {
    description = "Stop song",
    group = "volume",
  }),

  -- flameshot (screenshots)
  awful.key({ modkey, "Shift" }, "r", function()
    awful.spawn.with_shell("flameshot gui")
  end, {
    description = "Capture screen region",
    group = "screen",
  }),
  awful.key({ modkey, "Shift" }, "f", function()
    awful.spawn.with_shell("flameshot screen -p " .. os.getenv("HOME") .. "/Imágenes")
  end, {
    description = "Capture screen",
    group = "screen",
  }),
  awful.key({ modkey, "Shift" }, "y", function()
    awful.spawn.with_shell("flameshot screen -c")
  end, {
    description = "Capture screen (to clipboard)",
    group = "screen",
  }),

  -- Awesome key bindings
  awful.key(
    { modkey },
    "s",
    hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),
  awful.key(
    { modkey },
    "Left",
    awful.tag.viewprev,
    { description = "view previous", group = "tag" }
  ),
  awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key(
    { modkey },
    "Escape",
    awful.tag.history.restore,
    { description = "go back", group = "tag" }
  ),

  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, {
    description = "focus next by index",
    group = "client",
  }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, {
    description = "focus previous by index",
    group = "client",
  }),
  awful.key({ modkey }, "w", function()
    mymainmenu:show()
  end, {
    description = "show main menu",
    group = "awesome",
  }),
  awful.key(
    { modkey, "Control" },
    "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  awful.key(
    { modkey, "Shift" },
    "q",
    awesome.quit,
    { description = "quit awesome", group = "awesome" }
  ),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, {
    description = "swap with next client by index",
    group = "client",
  }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, {
    description = "swap with previous client by index",
    group = "client",
  }),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, {
    description = "focus the next screen",
    group = "screen",
  }),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, {
    description = "focus the previous screen",
    group = "screen",
  }),
  awful.key(
    { modkey },
    "u",
    awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }
  ),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, {
    description = "go back",
    group = "client",
  }),

  -- Standard program
  awful.key({ modkey }, "Return", function()
    awful.spawn(apps.terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),
  awful.key({ altkey }, "e", function()
    awful.spawn("codium")
  end, {
    description = "open VSCodium",
    group = "launcher",
  }),
  awful.key({ modkey }, "p", function()
    awful.spawn(string.format("%s/.local/bin/toggle-polybar", os.getenv("HOME")))
  end, {
    description = "toggle polybar",
    group = "launcher",
  }),
  awful.key({ modkey }, "c", function()
    awful.spawn(string.format("%s/.local/bin/toggle-picom", os.getenv("HOME")))
  end, {
    description = "toggle picom (compositor)",
    group = "launcher",
  }),

  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, {
    description = "increase master width factor",
    group = "layout",
  }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, {
    description = "decrease master width factor",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, {
    description = "increase the number of master clients",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, {
    description = "decrease the number of master clients",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, {
    description = "increase the number of columns",
    group = "layout",
  }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, {
    description = "decrease the number of columns",
    group = "layout",
  }),
  awful.key({ modkey, altkey }, "l", function()
    awful.layout.inc(1)
  end, {
    description = "select next",
    group = "layout",
  }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, {
    description = "select previous",
    group = "layout",
  }),

  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, {
    description = "restore minimized",
    group = "client",
  }),

  -- Menubar
  awful.key({ modkey }, "space", function()
    awful.spawn.with_shell("rofi -show combi")
  end, {
    description = "show the menubar",
    group = "launcher",
  })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, {
      description = "view tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, {
      description = "toggle tag #" .. i,
      group = "tag",
    }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, {
      description = "move focused client to tag #" .. i,
      group = "tag",
    }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, {
      description = "toggle focused client on tag #" .. i,
      group = "tag",
    })
  )
end

return globalkeys
