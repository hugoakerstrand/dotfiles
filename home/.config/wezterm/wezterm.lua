local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12.5
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.initial_cols = 100
config.initial_rows = 30

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

return config
