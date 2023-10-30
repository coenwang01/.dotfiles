---@type Wezterm
local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.log_info("reloading")

require("tabs").setup(config)
require("mouse").setup(config)
require("keys").setup(config)
require("links").setup(config)

--- setting

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
-- config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

--- color scheme
-- config.color_scheme = "Tokyo Night Moon"
config.color_scheme_dirs = { wezterm.home_dir .. "/Repos/tokyonight.nvim/extras/wezterm" }
config.color_scheme = "tokyonight_night"
wezterm.add_to_config_reload_watch_list(config.color_scheme_dirs[1] .. config.color_scheme .. ".toml")

config.underline_thickness = 3
config.cursor_thickness = 4
config.underline_position = -6

-- -- opacity
config.window_background_opacity = 0.85
-- config.term = "wezterm"
-- config.window_decorations = "RESIZE"
-- config.window_close_confirmation = "AlwaysPrompt"
-- config.scrollback_lines = 3000
-- config.default_workspace = "home"

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh" }
	config.window_decorations = "RESIZE|TITLE"
	wezterm.on("gui-startup", function(cmd)
		local screen = wezterm.gui.screens().active
		local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
		local gui = window:gui_window()
		local width = 0.7 * screen.width
		local height = 0.7 * screen.height
		gui:set_inner_size(width, height)
		gui:set_position((screen.width - width) / 2, (screen.height - height) / 2)
	end)
else
	config.term = "wezterm"
	config.window_decorations = "RESIZE"
end

--- font
config.font_size = 12
config.font = wezterm.font({ family = "Fira Code" })
config.bold_brightens_ansi_colors = true
config.font_rules = {
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({ family = "Maple Mono", weight = "Bold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({ family = "Maple Mono", weight = "DemiBold", style = "Italic" }),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({ family = "Maple Mono", style = "Italic" }),
	},
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.force_reverse_video_cursor = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
-- window_background_opacity = 0.9,
-- cell_width = 0.9,
config.scrollback_lines = 10000

config.adjust_window_size_when_changing_font_size = false

return config --[[@as Wezterm]]