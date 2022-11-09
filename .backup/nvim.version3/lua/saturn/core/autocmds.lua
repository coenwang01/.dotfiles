local M = {}
local Log = require "saturn.core.log"

--- Load the default set of autogroups and autocommands.
function M.load_defaults()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
      "Jaq",
      "qf",
      "help",
      "man",
      "lspinfo",
      "spectre_panel",
      "lir",
      "DressingSelect",
      "tsplayground",
    },
    callback = function()
      vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
    end,
  })
  local definitions = {
    {
      "TextYankPost",
      {
        group = "_general_settings",
        pattern = "*",
        desc = "Highlight text on yank",
        callback = function()
          require("vim.highlight").on_yank { higroup = "Search", timeout = 100 }
        end,
      },
    },
    {
      "FileType",
      {
        group = "_hide_dap_repl",
        pattern = "dap-repl",
        command = "set nobuflisted",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "qf",
        command = "set nobuflisted",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = { "gitcommit", "markdown" },
        command = "setlocal wrap spell",
      },
    },
    {
      "FileType",
      {
        group = "_buffer_mappings",
        pattern = { "qf", "help", "man", "floaterm", "lspinfo", "lsp-installer", "null-ls-info" },
        command = "nnoremap <silent> <buffer> q :close<CR>",
      },
    },
    {
      "VimResized",
      {
        group = "_auto_resize",
        pattern = "*",
        command = "tabdo wincmd =",
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "alpha",
        callback = function()
          vim.cmd [[
            nnoremap <silent> <buffer> q :qa<CR>
            nnoremap <silent> <buffer> <esc> :qa<CR>
            set nobuflisted
          ]]
        end,
      },
    },
    {
      "FileType",
      {
        group = "_filetype_settings",
        pattern = "lir",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      },
    },
  }

  M.define_autocmds(definitions)
end

local get_format_on_save_opts = function()
  local defaults = require("saturn.config.settings").format_on_save
  -- accept a basic boolean `saturn.format_on_save=true`
  if type(saturn.format_on_save) ~= "table" then
    return defaults
  end

  return {
    pattern = saturn.format_on_save.pattern or defaults.pattern,
    timeout = saturn.format_on_save.timeout or defaults.timeout,
  }
end

function M.enable_format_on_save()
  local opts = get_format_on_save_opts()
  vim.api.nvim_create_augroup("lsp_format_on_save", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "lsp_format_on_save",
    pattern = opts.pattern,
    callback = function()
      require("saturn.lsp.utils").format { timeout_ms = opts.timeout, filter = opts.filter }
    end,
  })
  Log:debug "enabled format-on-save"
end

function M.disable_format_on_save()
  M.clear_augroup "lsp_format_on_save"
  Log:debug "disabled format-on-save"
end

function M.configure_format_on_save()
  if saturn.format_on_save then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

function M.toggle_format_on_save()
  local exists, autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = "lsp_format_on_save",
    event = "BufWritePre",
  })
  if not exists or #autocmds == 0 then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

function M.enable_reload_config_on_save()
  local user_config_file = require("saturn.config"):get_user_config_path()

  if vim.loop.os_uname().version:match "Windows" then
    -- autocmds require forward slashes even on windows
    user_config_file = user_config_file:gsub("\\", "/")
  end
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "_general_settings",
    pattern = user_config_file,
    desc = "Trigger saturnReload on saving config.lua",
    callback = function()
      require("saturn.config"):reload()
    end,
  })
end

function M.enable_transparent_mode()
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      local hl_groups = {
        "Normal",
        "SignColumn",
        "NormalNC",
        "TelescopeBorder",
        "NvimTreeNormal",
        "EndOfBuffer",
        "MsgArea",
      }
      for _, name in ipairs(hl_groups) do
        vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
      end
    end,
  })
  vim.opt.fillchars = "eob: "
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function M.clear_augroup(name)
  -- defer the function in case the autocommand is still in-use
  Log:debug("request to clear autocmds  " .. name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds { group = name }
    end)
  end)
end

--- Create autocommand groups based on the passed definitions
--- Also creates the augroup automatically if it doesn't exist
---@param definitions table contains a tuple of event, opts, see `:h nvim_create_autocmd`
function M.define_autocmds(definitions)
  for _, entry in ipairs(definitions) do
    local event = entry[1]
    local opts = entry[2]
    if type(opts.group) == "string" and opts.group ~= "" then
      local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
      if not exists then
        vim.api.nvim_create_augroup(opts.group, {})
      end
    end
    vim.api.nvim_create_autocmd(event, opts)
  end
end

return M