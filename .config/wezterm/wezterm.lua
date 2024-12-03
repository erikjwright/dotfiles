local wezterm = require("wezterm")
local config = {}

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "tokyonight_night"
config.enable_tab_bar = false
config.font = wezterm.font("MesloLGM Nerd Font")
config.font_size = 12.5
-- config.scrollback_lines = 10000
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.window_background_opacity = 0.97
config.macos_window_background_blur = 100
config.native_macos_fullscreen_mode = true

return config
