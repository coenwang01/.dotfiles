-- Set a formatter.
local formatters = require "saturn.plugins.core.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
}

-- Set a linter.
local linters = require "saturn.plugins.core.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
}

-- Setup dap for python
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
  -- require("dap-python").setup("python")
end)

-- Setup lsp for python
local manager = require "saturn.plugins.core.lsp.manager"
manager.setup("pyright", {
  on_init = require("saturn.plugins.core.lsp").common_on_init,
  capabilities = require("saturn.plugins.core.lsp").common_capabilities(),
} )

-- Supported test frameworks are unittest, pytest and django. By default it
-- tries to detect the runner by probing for pytest.ini and manage.py, if
-- neither are present it defaults to unittest.
pcall(function()
  require("dap-python").test_runner = "pytest"
end)

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python" },
  callback = function()
    saturn.plugins.whichkey.mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
    saturn.plugins.whichkey.mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
    saturn.plugins.whichkey.vmappings["d"] = {
      name = "Debug",
      s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
    }
  end,
})
