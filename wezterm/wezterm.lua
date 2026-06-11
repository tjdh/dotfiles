local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8

config.colors = {
    cursor_bg = "#ffffff",
    cursor_fg = "#000000",
    cursor_border = "#ffffff",
}

config.mouse_bindings = {
    {
        event = { Drag = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.StartWindowDrag,
    },
}

config.keys = {
    {
        key = "v",
        mods = "CTRL",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
}

if wezterm.target_triple:find("linux") then
    config.enable_wayland = false
end

if wezterm.target_triple:find("windows") then
    config.default_prog = { "wsl.exe", "--cd", "~" }
    config.front_end = "OpenGL"
end

return config
