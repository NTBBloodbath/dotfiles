local awful = require('awful')
local beautiful = require('beautiful')
local client_keys = require('configuration.client.keybinds')
local client_buttons = require('configuration.client.buttons')
require('configuration.client.signals')

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = client_keys,
			buttons = client_buttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap
				+ awful.placement.no_offscreen,
		},
	},

	-- Remove borders from polybar
	{
		rule = { name = 'polybar' },
		properties = {
			border_width = 0,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				'copyq', -- Includes session name in class.
				'pinentry',
			},
			class = {
				'Arandr',
				'Kruler',
				'Wpa_gui',
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				'Event Tester', -- xev.
			},
			role = {
				'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { 'normal', 'dialog' } },
		properties = { titlebars_enabled = false },
	},

	-- Set windows tags and other custom properties
	{
		rule = { class = 'Chrome' },
		properties = { screen = 1, tag = '2' },
	},
	{
		rule = { class = 'kitty' },
		properties = { screen = 1, tag = '1' },
	},
	{
		rule = { name = 'Telegram' },
		properties = { screen = 1, tag = '3' },
	},
	{
		rule = { name = 'Discord' },
		properties = { screen = 1, tag = '3' },
	},
	{
		rule = { class = 'Godot' },
		properties = { screen = 1, tag = '5' },
	},
}
