local awful = require('awful')

-- Table of layouts to cover
awful.layout.layouts = {
	awful.layout.suit.spiral,
	awful.layout.suit.floating,
	awful.layout.suit.max.fullscreen,
}

-- Configure tag properties
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ '1', '2', '3', '4', '5' }, s, awful.layout.layouts[1])
end)
