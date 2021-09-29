local awful = require('awful')
local gears = require('gears')
local modkey = require('configuration.keybinds.mod').modKey

local client_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
		awful.mouse.client.resize(c)
	end)
)

return client_buttons
