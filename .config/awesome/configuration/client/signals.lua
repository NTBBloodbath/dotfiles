local awful = require('awful')
local beautiful = require('beautiful')

-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if
		awesome.startup
		and not c.size_hints.user_position
		and not c.size_hints.program_position
	then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Remove borders from maximized clients
client.connect_signal('property::maximized', function(c)
	-- Remove borders if only 1 client is visible
	if c.maximized then
		c.border_width = 0
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_focus
	end
end)
