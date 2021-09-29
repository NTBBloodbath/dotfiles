local apps = require('configuration.apps')

-- List of apps to start once on start-up
return {
	run_on_start_up = {
		-- Compositor
		'picom --config ' .. os.getenv('HOME') .. '/.config/picom/picom.conf',
		-- NetworkManager systray applet
		'nm-applet',
		-- Polybar
		os.getenv('HOME') .. '/.config/polybar/launch.sh awesome-top',
        -- Terminal
        apps.terminal,
        -- Screenshots tool
        'flameshot',
	},
}
