local wezterm = require("wezterm")

local gpu_adapters = require("utils.gpu_adapter")
-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local ADMIN_ICON = utf8.char(0xf49c)

local CMD_ICON = ""
local NU_ICON = utf8.char(0xe7a8)
local PS_ICON = utf8.char(0xe70f)
local ELV_ICON = utf8.char(0xfc6f)
local WSL_ICON = "󰌽"
local YORI_ICON = utf8.char(0xf1d4)
local NYA_ICON = utf8.char(0xf61a)

local VIM_ICON = ""
local PAGER_ICON = utf8.char(0xf718)
local FUZZY_ICON = utf8.char(0xf0b0)
local HOURGLASS_ICON = utf8.char(0xf252)
local SUNGLASS_ICON = utf8.char(0xf9df)

local PYTHON_ICON = utf8.char(0xf820)
local NODE_ICON = utf8.char(0xe74e)
local DENO_ICON = utf8.char(0xe628)
local LAMBDA_ICON = utf8.char(0xfb26)

local SUP_IDX = {
	"¹",
	"²",
	"³",
	"⁴",
	"⁵",
	"⁶",
	"⁷",
	"⁸",
	"⁹",
	"¹⁰",
	"¹¹",
	"¹²",
	"¹³",
	"¹⁴",
	"¹⁵",
	"¹⁶",
	"¹⁷",
	"¹⁸",
	"¹⁹",
	"²⁰",
}
local SUB_IDX = {
	"₁",
	"₂",
	"₃",
	"₄",
	"₅",
	"₆",
	"₇",
	"₈",
	"₉",
	"₁₀",
	"₁₁",
	"₁₂",
	"₁₃",
	"₁₄",
	"₁₅",
	"₁₆",
	"₁₇",
	"₁₈",
	"₁₉",
	"₂₀",
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"
	local dim_foreground = "#3A3A3A"

	if tab.is_active then
		background = "#FBB829"
		foreground = "#1C1B19"
	elseif hover then
		background = "#FF8700"
		foreground = "#1C1B19"
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name
	local pane_title = tab.active_pane.title
	local exec_name = basename(process_name):gsub("%.exe$", "")
	local title_with_icon = ""

	if exec_name == "nu" then
		title_with_icon = NU_ICON .. " NuShell"
	elseif exec_name == "pwsh" then
		title_with_icon = PS_ICON .. " PWSH"
	elseif exec_name == "cmd" then
		title_with_icon = CMD_ICON .. " CMD"
	elseif exec_name == "elvish" then
		title_with_icon = ELV_ICON .. " Elvish"
	elseif exec_name == "wsl" or exec_name == "wslhost" then
		title_with_icon = WSL_ICON .. " Arch"
	elseif exec_name == "nyagos" then
		title_with_icon = NYA_ICON .. " " .. pane_title:gsub(".*: (.+) %- .+", "%1")
	elseif exec_name == "yori" then
		title_with_icon = YORI_ICON .. " " .. pane_title:gsub(" %- Yori", "")
	elseif exec_name == "nvim" then
		title_with_icon = VIM_ICON
		-- .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
	elseif exec_name == "bat" or exec_name == "less" or exec_name == "moar" then
		title_with_icon = PAGER_ICON .. " " .. exec_name:upper()
	elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
		title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
	elseif exec_name == "btm" or exec_name == "ntop" then
		title_with_icon = SUNGLASS_ICON .. " " .. exec_name:upper()
	elseif exec_name == "python" or exec_name == "hiss" then
		title_with_icon = PYTHON_ICON .. " " .. exec_name
	elseif exec_name == "node" then
		title_with_icon = NODE_ICON .. " " .. exec_name:upper()
	elseif exec_name == "deno" then
		title_with_icon = DENO_ICON .. " " .. exec_name:upper()
	elseif exec_name == "bb" or exec_name == "cmd-clj" or exec_name == "janet" or exec_name == "hy" then
		title_with_icon = LAMBDA_ICON .. " " .. exec_name:gsub("bb", "Babashka"):gsub("cmd%-clj", "Clojure")
	else
		title_with_icon = HOURGLASS_ICON .. " " .. exec_name
	end

	if pane_title:match("^Administrator: ") then
		title_with_icon = title_with_icon .. " " .. ADMIN_ICON
	end
	local left_arrow = SOLID_LEFT_ARROW
	if tab.tab_index == 0 then
		left_arrow = SOLID_LEFT_MOST
	end
	local id = SUB_IDX[tab.tab_index + 1]
	local pid = SUP_IDX[tab.active_pane.pane_index + 1]
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = id },
		{ Text = title },
		{ Foreground = { Color = dim_foreground } },
		{ Text = pid },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end)

return {
	-- # appearance
	--
	initial_cols = 90,
	initial_rows = 25,
	--
	front_end = "WebGpu",
	-- webgpu_power_preference = "HighPerformance",
	-- webgpu_preferred_adapter = gpu_adapters:pick_best(),

	color_scheme = "Catppuccin Macchiato",
	audible_bell = "Disabled",
	cursor_blink_ease_in = "EaseIn",
	cursor_blink_ease_out = "EaseOut",
	cursor_blink_rate = 1500,
	default_cursor_style = "BlinkingBar",
	cursor_thickness = "2px",
	animation_fps = 60,
	max_fps = 60,
	dpi = 96.0,
	-- -- ## window
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	integrated_title_button_alignment = "Right",
	integrated_title_button_color = "Auto",
	integrated_title_button_style = "Gnome",
	integrated_title_buttons = { "Hide", "Close" },
	window_close_confirmation = "NeverPrompt",
	window_padding = {
		left = 3,
		right = 0,
		top = 2,
		bottom = 0,
	},
	window_frame = {
		border_left_width = "2px",
		border_right_width = "2px",
		border_bottom_height = "2px",
		border_top_height = "2px",
		border_left_color = "#569cd6",
		border_right_color = "#569cd6",
		border_bottom_color = "#569cd6",
		border_top_color = "#569cd6",
	},
	-- font
	font_dirs = { "fonts" },
	font_size = 16,
	freetype_load_target = "Normal",
	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font Mono",
		"Cascadia Mono NF",
		"LXGW WenKai Mono",
	}),

	-- tab
	tab_max_width = 45,
	-- hide_tab_bar_if_only_one_tab = true,
	enable_scroll_bar = false,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.90,

	set_environment_variables = {
		LANG = "en_US.UTF-8",
		PATH = wezterm.executable_dir .. ";" .. os.getenv("PATH"),
	},
	colors = {
		tab_bar = {
			background = "#121212",
			new_tab = { bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold" },
			new_tab_hover = { bg_color = "#121212", fg_color = "#FBB829", intensity = "Bold" },
			active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
			inactive_tab = { bg_color = "#121212", fg_color = "#808080" },
		},
	},
	window_background_gradient = {
		orientation = "Vertical",
		interpolation = "Linear",
		blend = "Rgb",
		colors = {
			"#121212",
			"#202020",
		},
	},
	visual_bell = {
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 75,
		target = "CursorColor",
	},

	-- launch menu
	default_prog = { "wsl.exe", "~", "-d", "Arch" },
	launch_menu = {
		{ label = "PowerShell Core", args = { "pwsh" } },
		{ label = "Command Prompt", args = { "cmd" } },
		{ label = "WSL Arch", args = { "wsl.exe", "~", "-d", "Arch" } },
		{ label = "WSL Ubuntu", args = { "wsl.exe", "~", "-d", "Ubuntu" } },
	},

	-- mapping
	disable_default_key_bindings = true,
	-- ALT = { key="`"},
	keys = {
		{ key = "F1", mods = "NONE", action = wezterm.action.ActivateCommandPalette },
		{
			key = "F4",
			mods = "NONE",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
		},
		{ key = "F11", mods = "NONE", action = "ToggleFullScreen" },
		{ key = "c", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "d", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "a", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		-- { key = "Insert", mods = "SHIFT", action = wezterm.action({ PasteFrom = "PrimarySelection" }) },
		-- { key = "Insert", mods = "CTRL", action = wezterm.action({ CopyTo = "PrimarySelection" }) },
		{
			key = "v",
			mods = "ALT",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "h", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "l", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "j", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "H", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "J", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 3 }) },
		{ key = "K", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 3 }) },
		{ key = "L", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
		{ key = "z", mods = "ALT", action = "TogglePaneZoomState" },
		{ key = "/", mods = "ALT", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
		{ key = "q", mods = "ALT", action = "QuickSelect" },
		{ key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "o", mods = "ALT", action = "ActivateLastTab" },
		{ key = "g", mods = "ALT", action = "ShowTabNavigator" },
		{ key = "r", mods = "ALT", action = "ReloadConfiguration" },
		{ key = "w", mods = "ALT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "w", mods = "ALT|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	},
}
