local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
    enable_tab_bar = false,
    enable_wayland = false,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    window_background_opacity = 0.8,
    colors = {
        cursor_bg = "#ffffff",
        cursor_fg = "#000000",
        cursor_border = "#ffffff",
    },
    mouse_bindings = {
        {
            event = { Drag = { streak = 1, button = "Left"} },
            mods = "CTRL",
            action = wezterm.action.StartWindowDrag,
        },
    },
    keys = {
        {
            key = "v",
            mods = "CTRL",
            action = wezterm.action.PasteFrom("Clipboard"),
        },
    },
}

return config
