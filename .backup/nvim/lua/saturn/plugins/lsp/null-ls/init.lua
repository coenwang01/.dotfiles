local M = {}

local Log = require "saturn.plugins.log"

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end

  local default_opts = require("saturn.plugins.lsp").get_common_opts()
  null_ls.setup(vim.tbl_deep_extend("force", default_opts, saturn.lsp.null_ls.setup))
end

return M
