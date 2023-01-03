local M = {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
}

function M.init()
  saturn.plugins.copilot = {
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "<M-r>",
        open = "<M-space>",
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = false,
      debounce = 75,
      keymap = {
        accept = "<M-cr>",
        next = "<M-i>",
        prev = "<M-n>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
    copilot_node_command = "node", -- Node version must be < 18
    cmp = {
      enabled = true,
      method = "getCompletionsCycling",
    },
    -- plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer",
    server_opts_overrides = {
      -- trace = "verbose",
      settings = {
        advanced = {
          -- listCount = 10, -- #completions for panel
          inlineSuggestCount = 3, -- #completions for getCompletions
        },
      },
    },
  }
end

-- function M.config()
--   vim.defer_fn(function()
--     M.setup()
--   end, 100)
-- end

function M.setup()
  -- local present, copilot = pcall(require, "copilot")
  -- if not present then
  --   return
  -- end

  require("copilot").setup(saturn.plugins.copilot)
end

return M
