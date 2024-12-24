local wezterm = require("wezterm")
local act = wezterm.action

local config = {
    color_scheme = "tokyonight_night",
    enable_tab_bar = false,
    font = wezterm.font("MesloLGM Nerd Font"),
    font_size = 12.5,
    scrollback_lines = 10000,
    default_cursor_style = "BlinkingBlock",
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    window_background_opacity = 0.97,
    macos_window_background_blur = 100,
    native_macos_fullscreen_mode = true,
    leader = { key = "Space", mods = "CTRL" },
    keys = {
        {
            key = "-",
            mods = "LEADER",
            action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "\\",
            mods = "LEADER",
            action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
        { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Prev" }) },
        { key = "k", mods = "LEADER", action = act.ScrollByPage(-0.5) },
        { key = "j", mods = "LEADER", action = act.ScrollByPage(0.5) },
    },
}

return config
