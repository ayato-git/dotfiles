local wezterm = require('wezterm');
local config = wezterm.config_builder()

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(0, 0)
end)

config.animation_fps = 60
config.font = wezterm.font('UDEV Gothic NFLG')
config.font_size = 14.5
config.color_scheme = 'Molokai'
config.window_background_opacity = 0.75
config.window_decorations = 'RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.adjust_window_size_when_changing_font_size = false
config.initial_rows = 60
config.keys = {
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  {
    key = '¥',
    mods = 'ALT',
    action = wezterm.action({ SendString = '\\' })
  },
}

return config
