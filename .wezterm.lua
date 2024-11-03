local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS NF")
config.font_size = 12.8
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.keys = {
	{ key = 'Z', mods = 'CTRL', action = wezterm.action.TogglePaneZoomState },
}

return config
