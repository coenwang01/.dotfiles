return {
  leaderkey = " ",
  colorscheme = "tokyonight",
  transparent_window = false,
  format_on_save = {
    ---@usage boolean: format on save (Default: false)
    enabled = false,
    ---@usage pattern string pattern used for the autocommand (Default: '*')
    pattern = "*",
    ---@usage timeout number timeout in ms for the format request (Default: 1000)
    timeout = 1000,
    ---@usage filter func to select client
    -- filter = require("saturn.plugins.core.lsp.utils").format_filter,
  },
  keys = {},
  use_icons = true,
  icons = require "saturn.basic.ui.icons",
  plugins = {},
  enable_extra_plugins = true,
  log = {
    ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
    level = "warn",
    viewer = {
      ---@usage this will fallback on "less +F" if not found
      cmd = "lnav",
      layout_config = {
        ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
        direction = "horizontal",
        open_mapping = "",
        size = 40,
        float_opts = {},
      },
    },
    -- currently disabled due to instabilities
    override_notify = false,
  },
}
