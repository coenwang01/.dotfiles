local M = {
  "akinsho/toggleterm.nvim",
  branch = "main",
  cmd = "ToggleTerm",
}

M.keys = {
  { "<leader>xp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python" },
  { "<leader>xf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float" },
  { "<leader>xh", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal" },
  { "<leader>xv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical" },
  {
    "<leader>gg",
    function()
      M.lazygit_toggle()
    end,
    desc = "Lazygit",
  },
}

function M.init()
  saturn.plugins.whichkey.mappings.x = {
    name = "terminal",
  }
end

saturn.plugins.toggleterm = {
  active = true,
  on_config_done = nil,
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true, -- close the terminal window when the process exits
  direction = "float", -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    -- The border key is *almost* the same as 'nvim_win_open'
    -- see :h nvim_win_open for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    border = "curved",
    -- width = <value>,
    -- height = <value>,
    winblend = 0,
    highlight = {
      border = "Normal",
      backgrounds = "Normal",
    },
  },
  -- Add executables on the config.lua
  -- { exec, keymap, description, direction, size }
  -- saturn.plugins.toggleterm.execs = {...} to overwrite
  -- saturn.plugins.toggleterm.execs[#saturn.plugins.toggleterm.execs+1] = {"gdb", "tg", "GNU Debugger"}
  -- TODO: pls add mappings in which key and refactor this
  execs = {
    { nil, "<M-S-1>", "Horizontal Terminal", "horizontal", 0.3 },
    { nil, "<M-S-2>", "Vertical Terminal", "vertical", 0.4 },
    { nil, "<M-S-3>", "Float Terminal", "float", nil },
  },
}

--- Get current buffer size
---@return {width: number, height: number}
local function get_buf_size()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufinfo = vim.tbl_filter(function(buf)
    return buf.bufnr == cbuf
  end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
  if bufinfo == nil then
    return { width = -1, height = -1 }
  end
  return { width = bufinfo.width, height = bufinfo.height }
end

--- Get the dynamic terminal size in cells
---@param direction number
---@param size number
---@return integer
local function get_dynamic_terminal_size(direction, size)
  size = size or saturn.plugins.toggleterm.size
  if direction ~= "float" and tostring(size):find(".", 1, true) then
    size = math.min(size, 1.0)
    local buf_sizes = get_buf_size()
    local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
    return buf_size * size
  else
    return size
  end
end

function M.config()
  local toggleterm = require("toggleterm")
  toggleterm.setup(saturn.plugins.toggleterm)

  for i, exec in pairs(saturn.plugins.toggleterm.execs) do
    local direction = exec[4] or saturn.plugins.toggleterm.direction

    local opts = {
      cmd = exec[1] or saturn.plugins.toggleterm.shell,
      keymap = exec[2],
      label = exec[3],
      -- NOTE: unable to consistently bind id/count <= 9, see #2146
      count = i + 100,
      direction = direction,
      size = function()
        return get_dynamic_terminal_size(direction, exec[5])
      end,
    }

    M.add_exec(opts)
  end

  if saturn.plugins.toggleterm.on_config_done then
    saturn.plugins.toggleterm.on_config_done(toggleterm)
  end
end

M.add_exec = function(opts)
  local binary = opts.cmd:match("(%S+)")
  if vim.fn.executable(binary) ~= 1 then
    Log:debug("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
    return
  end

  vim.keymap.set({ "n", "t" }, opts.keymap, function()
    M._exec_toggle({ cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() })
  end, { desc = opts.label, noremap = true, silent = true })
end

M._exec_toggle = function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({ cmd = opts.cmd, count = opts.count, direction = opts.direction })
  term:toggle(opts.size, opts.direction)
end

---Toggles a log viewer according to log.viewer.layout_config
---@param logfile string the fullpath to the logfile
M.toggle_log_view = function(logfile)
  local log_viewer = saturn.log.viewer.cmd
  if vim.fn.executable(log_viewer) ~= 1 then
    log_viewer = "less +F"
  end
  Log:debug("attempting to open: " .. logfile)
  log_viewer = log_viewer .. " " .. logfile
  local term_opts = vim.tbl_deep_extend("force", saturn.plugins.toggleterm, {
    cmd = log_viewer,
    open_mapping = saturn.log.viewer.layout_config.open_mapping,
    direction = saturn.log.viewer.layout_config.direction,
    -- TODO: this might not be working as expected
    size = saturn.log.viewer.layout_config.size,
    float_opts = saturn.log.viewer.layout_config.float_opts,
  })

  local Terminal = require("toggleterm.terminal").Terminal
  local log_view = Terminal:new(term_opts)
  log_view:toggle()
end

M.lazygit_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd("startinsert!")
    end,
    on_close = function(_) end,
    count = 99,
  })
  lazygit:toggle()
end

return M
