local M = {}

M.config = function()
  saturn.builtin.illuminate = {
    active = true,
    on_config_done = nil,
    options = {
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- delay: delay in milliseconds
      delay = 120,
      -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "packer",
        "neogitstatus",
        "Trouble",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },
      -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
      filetypes_allowlist = {},
      -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
      modes_denylist = {},
      -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
      modes_allowlist = {},
      -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
      -- Only applies to the 'regex' provider
      -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
      providers_regex_syntax_denylist = {},
      -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
      -- Only applies to the 'regex' provider
      -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
      providers_regex_syntax_allowlist = {},
      -- under_cursor: whether or not to illuminate under the cursor
      under_cursor = true,
    },
  }
end

M.setup = function()
  local status_ok, illuminate = pcall(reload, "illuminate")
  if not status_ok then
    return
  end

  local config_ok, _ = pcall(illuminate.configure, saturn.builtin.illuminate.options)
  if not config_ok then
    return
  end

  if saturn.builtin.illuminate.on_config_done then
    saturn.builtin.illuminate.on_config_done()
  end
end

return M