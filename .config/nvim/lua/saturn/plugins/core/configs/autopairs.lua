local M = {}

function M.config()
  saturn.plugins.core.autopairs = {
    active = true,
    on_config_done = nil,
    ---@usage  modifies the function or method delimiter by filetypes
    map_char = {
      all = "(",
      tex = "{",
    },
    ---@usage check bracket in same line
    enable_check_bracket_line = false,
    ---@usage check treesitter
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    enable_moveright = true,
    ---@usage disable when recording or executing a macro
    disable_in_macro = false,
    ---@usage add bracket pairs after quote
    enable_afterquote = true,
    ---@usage map the <BS> key
    map_bs = true,
    ---@usage map <c-w> to delete a pair if possible
    map_c_w = false,
    ---@usage disable when insert after visual block mode
    disable_in_visualblock = false,
    ---@usage  change default fast_wrap
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  }
end

M.setup = function()
  local status_ok, autopairs = pcall(require, "nvim-autopairs")
  if not status_ok then
    return
  end
  local Rule = require "nvim-autopairs.rule"

  autopairs.setup {
    check_ts = saturn.plugins.core.autopairs.check_ts,
    enable_check_bracket_line = saturn.plugins.core.autopairs.enable_check_bracket_line,
    ts_config = saturn.plugins.core.autopairs.ts_config,
    disable_filetype = saturn.plugins.core.autopairs.disable_filetype,
    disable_in_macro = saturn.plugins.core.autopairs.disable_in_macro,
    ignored_next_char = saturn.plugins.core.autopairs.ignored_next_char,
    enable_moveright = saturn.plugins.core.autopairs.enable_moveright,
    enable_afterquote = saturn.plugins.core.autopairs.enable_afterquote,
    map_c_w = saturn.plugins.core.autopairs.map_c_w,
    map_bs = saturn.plugins.core.autopairs.map_bs,
    disable_in_visualblock = saturn.plugins.core.autopairs.disable_in_visualblock,
    fast_wrap = saturn.plugins.core.autopairs.fast_wrap,
  }

  require("nvim-treesitter.configs").setup { autopairs = { enable = true } }

  local ts_conds = require "nvim-autopairs.ts-conds"

  -- TODO: can these rules be safely added from "config.lua" ?
  -- press % => %% is only inside comment or string
  autopairs.add_rules {
    Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
  }

  if saturn.plugins.core.autopairs.on_config_done then
    saturn.plugins.core.autopairs.on_config_done(autopairs)
  end
  pcall(function()
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end)
end

return M
