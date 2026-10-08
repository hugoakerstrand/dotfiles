local wezterm = require("wezterm")
local act = wezterm.action

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
config.audible_bell = "Disabled" -- mute the bell from every program, not just the shell

-- Dim unfocused windows so the focused one is obvious at a glance.
local UNFOCUSED_FOREGROUND_TEXT_HSB = { hue = 1.0, saturation = 0.25, brightness = 0.45 }
local UNFOCUSED_WINDOW_BACKGROUND_OPACITY = 0.62

-- macOS-style shortcuts. Inside herdr, forward the raw prefix (ctrl+b = \x02)
-- sequence, mirroring the remaps in home/.config/herdr/config.toml. Outside
-- herdr, run the equivalent native WezTerm action, so the chords keep the
-- same muscle memory everywhere.
local HERDR_PREFIX = "\x02"

local function is_herdr(pane)
	local process_name = pane:get_foreground_process_name() or ""
	return process_name:find("herdr", 1, true) ~= nil
end

local function herdr_or(herdr_key, native_action)
	local herdr_action = act.SendString(HERDR_PREFIX .. herdr_key)
	return wezterm.action_callback(function(window, pane)
		window:perform_action(is_herdr(pane) and herdr_action or native_action, pane)
	end)
end

config.keys = {
	{ key = "t", mods = "CMD", action = herdr_or("t", act.SpawnTab("CurrentPaneDomain")) },
	{ key = "w", mods = "CMD", action = herdr_or("w", act.CloseCurrentPane({ confirm = true })) },
	{ key = "w", mods = "CMD|SHIFT", action = herdr_or("W", act.CloseCurrentTab({ confirm = true })) },
	{ key = "n", mods = "CMD", action = herdr_or("n", act.SpawnWindow) },
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = herdr_or(
			"R",
			act.PromptInputLine({
				description = "Rename tab",
				action = wezterm.action_callback(function(window, _pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			})
		),
	},
	-- cmd+d / cmd+shift+d follow the macOS Terminal.app/iTerm2 convention:
	-- plain d splits side-by-side, shift+d stacks top-to-bottom.
	{ key = "d", mods = "CMD", action = herdr_or("d", act.SplitPane({ direction = "Right", size = { Percent = 50 } })) },
	{ key = "d", mods = "CMD|SHIFT", action = herdr_or("D", act.SplitPane({ direction = "Down", size = { Percent = 50 } })) },
	{ key = "h", mods = "CMD|ALT", action = herdr_or("h", act.ActivatePaneDirection("Left")) },
	{ key = "j", mods = "CMD|ALT", action = herdr_or("j", act.ActivatePaneDirection("Down")) },
	{ key = "k", mods = "CMD|ALT", action = herdr_or("k", act.ActivatePaneDirection("Up")) },
	{ key = "l", mods = "CMD|ALT", action = herdr_or("l", act.ActivatePaneDirection("Right")) },
	{ key = "[", mods = "CMD", action = herdr_or("[", act.ActivatePaneDirection("Prev")) },
	{ key = "]", mods = "CMD", action = herdr_or("]", act.ActivatePaneDirection("Next")) },
	{ key = "Enter", mods = "CMD|SHIFT", action = herdr_or("z", act.TogglePaneZoomState) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = herdr_or(tostring(i), act.ActivateTab(i - 1)), -- jump to workspace/tab i
	})
end

return config
