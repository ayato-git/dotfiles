local wezterm = require 'wezterm';

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(0, 0)
end)

local shortcutkeys = {
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
}

return {
  font = wezterm.font_with_fallback({
    {family = "HackGen Console NF", assume_emoji_presentation = false},
    {family = "HackGen Console NF", assume_emoji_presentation = true}
  }),
  use_ime = true,
  font_size = 14.5,
  color_scheme = "Molokai",
  window_background_opacity = 0.75,
  window_decorations = 'RESIZE',
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  adjust_window_size_when_changing_font_size = false,
  initial_rows = 60,
  keys = shortcutkeys,
}
