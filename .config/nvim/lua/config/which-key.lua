local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20,  -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-e>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "e", "u" },
    v = { "e", "u" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  a = {
    name = "Align"
  },
  b = {
    name = "Buffers",
    b = {
      "<cmd>Telescope buffers<cr>",
      "Find buffer",
    },
    D = {
      "<cmd>%bd|e#|bd#<cr>",
      "Close all but the current buffer",
    },
    d = { "<cmd>Bdelete!<CR>", "Close buffer" },
    n = { "<cmd>:bprevious<CR>", "Move Previous buffer" },
    i = { "<cmd>:bnext<CR>", "Move next buffer" },
  },
  e = {
    name = "Explorer",
    e = {
      "<cmd>NvimTreeToggle<CR>",
      "Project"
    },
    E = {
      "<cmd>NvimTreeFindFile<CR>",
      "Current File"
    },
    c = {
      "<cmd>:NvimTreeCollapse<CR>",
      "Collapse"
    },
    s = {
      "<cmd>:SymbolsOutline<CR>",
      "SymbolsOutline"
    },
  },
  f = {
    name = "Files",
    b = { "<cmd>Telescope file_browser<cr>", "File browser" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    l = { "<cmd>Lf<cr>", "Open LF" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    s = { "<cmd>w<cr>", "Save Buffer" },
    z = { "<cmd>Telescope zoxide list<CR>", "Zoxide" },
    q = { "<cmd>:q<CR>", "Quit"},
  },
  t = {
    e = {
      "<cmd>:tabe<CR>", "New Tab"
    },
    E = {
      "<cmd>:tab split<CR>", "New and Move the Tab"
    },
    n = {
      "<cmd>:-tabnext<CR>", "Move to Left Tab"
    },
    i = {
      "<cmd>:+tabnext<CR>", "Move to Right Tab"
    },
    N = {
      "<cmd>:-tabmove<CR>", "Move The Tab to Left"
    },
    I = {
      "<cmd>:+tabmove<CR>", "Move The Tab to Right"
    },
  },
  T = {
    name = "Terminal",
    -- o = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
    -- u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
    -- h = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },
  q = {
    name = "Quickfix",
    e = { "<cmd>cnext<cr>", "Next Quickfix Item" },
    u = { "<cmd>cprevious<cr>", "Previous Quickfix Item" },
    q = { "<cmd>lua require('functions').toggle_qf()<cr>", "Toggle quickfix list" },
    t = { "<cmd>TodoQuickFix<cr>", "Show TODOs" },
  },
  v = {
    name = "Visual",
    v = { "v$h", "Select current line" },
    w = { "viwp", "Paste ahd replace a word" },
  },
  w = {
    name = "Window",
    w = {
      "<C-w>w", "Switch To Next Window"
    },
    u = {
      "<C-w>k", "Switch To Up Window"
    },
    e = {
      "<C-w>j", "Switch To Down Window"
    },
    n = {
      "<C-w>h", "Switch To Letf Window"
    },
    i = {
      "<C-w>l", "Switch To Right Window"
    },
    q = {
      "<C-w>o", "Quit All Other Windows"
    },
  },
  s = {
    name = "Split",
    u = { "<cmd>:set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", "Split Up Window" },
    e = { "<cmd>:set splitbelow<CR>:split<CR>", "Split Down Window" },
    n = { "<cmd>:set nosplitright<CR>:vsplit<CR>:set splitright<CR>", "Split Left Window" },
    i = { "<cmd>:set splitright<CR>:vsplit<CR>", "Split Right Window" },
    h = { "<C-w>t<C-w>K", "Place Screens Horizontal" },
    v = { "<C-w>t<C-w>H", "Place Screens Vertical" },
    U = { "<cmd>:res +5<CR>", "Resize Up" },
    E = { "<cmd>:res -5<CR>", "Resize Down" },
    N = { "<cmd>:vertical resize-5<CR>", "Resize Left" },
    I = { "<cmd>:vertical resize+5<CR>", "Resize Right" },
    H = { "<C-w>b<C-w>K", "Rotate Screens Horizontal" },
    V = { "<C-w>b<C-w>H", "Rotate Screens Vertical" },
  },
  S = {
    name = "Search",
    s = { "<cmd>:%s//g<left><left>", "Find and Search" },
  },
  x = {
    name = "LanguageTool",
    c = { "<cmd>GrammarousCheck<cr>", "Grammar check" },
    i = { "<Plug>(grammarous-open-info-window)", "Open the info window" },
    r = { "<Plug>(grammarous-reset)", "Reset the current check" },
    f = { "<Plug>(grammarous-fixit)", "Fix the error under the cursor" },
    x = {
      "<Plug>(grammarous-close-info-window)",
      "Close the information window",
    },
    e = {
      "<Plug>(grammarous-remove-error)",
      "Remove the error under the cursor",
    },
    n = {
      "<Plug>(grammarous-move-to-next-error)",
      "Move cursor to the next error",
    },
    p = {
      "<Plug>(grammarous-move-to-previous-error)",
      "Move cursor to the previous error",
    },
    d = {
      "<Plug>(grammarous-disable-rule)",
      "Disable the grammar rule under the cursor",
    },
  },
  z = {
    name = "Spelling",
    n = { "]s", "Next" },
    p = { "[s", "Previous" },
    a = { "zg", "Add word" },
    f = { "1z=", "Use 1. correction" },
    l = { "<cmd>Telescope spell_suggest<cr>", "List corrections" },
  },
}
which_key.setup(setup)
which_key.register(mappings, opts)