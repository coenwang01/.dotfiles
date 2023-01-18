return {
  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    keys = {
      {
        "j",
        "<cmd>lua require('leap').leap { target_windows = { vim.fn.win_getid() } }<cr>",
        desc = "jump",
        mode = { "n", "x" },
      },
      {
        "gj",
        "<cmd>lua require('leap').leap { target_windows = vim.tbl_filter(function (win) return vim.api.nvim_win_get_config(win).focusable end,vim.api.nvim_tabpage_list_wins(0))}<cr>",
        desc = "jump to any window",
        mode = { "n", "x" },
      },
      { "f", "<Plug>(leap-forward-to)", desc = "leap forward to", mode = { "n", "x" } },
      { "F", "<Plug>(leap-backward-to)", desc = "leap backward to", mode = { "n", "x" } },
      -- { "t", "<Plug>(leap-forward-till)", desc = "leap forward till", mode = { "n", "x" } },
      -- { "T", "<Plug>(leap-backward-till)", desc = "leap backward till", mode = { "n", "x" } },
      { "gs", "<Plug>(leap-cross-window)", desc = "leap cross window", mode = { "n", "x" } },
    },
    -- dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "o" } } },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      -- leap.add_default_mappings(true)
    end,
  },
  -- {
  --   "phaazon/hop.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     local hop = require("hop")
  --     hop.setup({ keys = "eariosthdfuwyqzxcvbkmj" })
  --     local directions = require("hop.hint").HintDirection
  --     vim.keymap.set("", "j", ":HopChar1<cr>", { silent = true })
  --     vim.keymap.set("", "<C-j>", ":HopChar2<cr>", { silent = true, desc = "Jump" })
  --     vim.keymap.set("", "<leader>jj", ":HopPattern<cr>", { silent = true, desc = "Jump" })
  --     vim.keymap.set("", "f", function()
  --       hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  --     end, { remap = true })
  --     vim.keymap.set("", "F", function()
  --       hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  --     end, { remap = true })
  --     vim.keymap.set("", "t", function()
  --       hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  --     end, { remap = true })
  --     vim.keymap.set("", "T", function()
  --       hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  --     end, { remap = true })
  --   end,
  -- },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter",
    },
    opts = {
      tabkey = "<tab>", -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = "<s-tab>", -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = true, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_shift_tab = "<C-d>", -- reverse shift default action,
      enable_backwards = false, -- well ...
      completion = true, -- if the tabkey is used in a completion pum
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
      },
      ignore_beginning = false, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      exclude = { "markdown" }, -- tabout will ignore these filetypes
    },
  },
  {
    "karb94/neoscroll.nvim",
    keys = {
      { "<C-k>", mode = { "n", "v" } },
      { "<C-d>", mode = { "n", "v" } },
      { "<C-b>", mode = { "n", "v" } },
      { "<C-f>", mode = { "n", "v" } },
      { "<C-y>", mode = { "n", "v" } },
      { "<C-m>", mode = { "n", "v" } },
      { "zt", mode = "n" },
      { "zz", mode = "n" },
      { "zb", mode = "n" },
    },
    config = function()
      require("neoscroll").setup({
        easing_function = "quadratic", -- Default easing function
        -- Set any other options as needed
      })

      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      -- Use the "sine" easing function
      t["<C-k>"] = { "scroll", { "-vim.wo.scroll", "true", "350", [['sine']] } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350", [['sine']] } }
      -- Use the "circular" easing function
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
      -- Pass "nil" to disable the easing animation (constant scrolling speed)
      t["<C-y>"] = { "scroll", { "-0.10", "false", "100", nil } }
      t["<C-m>"] = { "scroll", { "0.10", "false", "100", nil } }
      -- When no easing function is provided the default easing function (in this case "quadratic") will be used
      t["zt"] = { "zt", { "300" } }
      t["zz"] = { "zz", { "300" } }
      t["zb"] = { "zb", { "300" } }

      require("neoscroll.config").set_mappings(t)
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {
          config = { engine = "nvim-cmp" },
        },
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Documents/notes",
            },
          },
        },
        ["core.integrations.nvim-cmp"] = {},
      },
    },
  },
  -- Preview number Jump
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup({
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
        -- hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
        -- number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
        -- centered_peeking = true, -- Peeked line will be centered relative to window
      })
    end,
  },
  -- Join
  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>" },
    },
    opts = { use_default_keymaps = false },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>R",
        function()
          require("ssr").open()
        end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    config = function()
      require("zen_mode").setup({
        window = {
          backdrop = 1,
          height = 0.9,
          -- width = 0.5,
          width = 80,
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = true,
            cursorcolumn = false, -- disable cursor column
            -- foldcolumn = "0", -- disable fold column
            -- list = false, -- disable whitespace characters
          },
        },
        plugins = {
          gitsigns = { enabled = false },
          tmux = { enabled = true },
          twilight = { enabled = true },
        },
        on_open = function()
          require("lsp-inlayhints").toggle()
          vim.g.cmp_active = false
          vim.cmd([[LspStop]])
          vim.opt.relativenumber = false
        end,
        on_close = function()
          require("lsp-inlayhints").toggle()
          vim.g.cmp_active = true
          vim.cmd([[LspStart]])
          vim.opt.relativenumber = true
        end,
      })
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight" },
    keys = {
      { "<leader>zt", "<cmd>Twilight<cr>", desc = "Twilight" },
    },
    config = true,
  },
  --TODO:session management
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup({
        filetypes = { "*", "!lazy" },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = { "*", "!prompt", "!nofile" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = false, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          virtualtext = saturn.icons.misc.Palette,
        },
      })

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {
          "*.css",
        },
        callback = function()
          require("colorizer").attach_to_buffer(0, { mode = "background", css = true })
        end,
      })
    end,
  },
  -- {
  --   "echasnovski/mini.move",
  --   keys = function(plugin, keys)
  --     -- Populate the keys based on the user's options
  --     local opts = require("lazy.core.plugin").values(plugin, "opts", false)
  --     local mappings = {
  --       { opts.mappings.left, desc = "move left", mode = { "n", "v" } },
  --       { opts.mappings.right, desc = "move right", mode = { "n", "v" } },
  --       { opts.mappings.down, desc = "move down", mode = { "n", "v" } },
  --       { opts.mappings.up, desc = "move up", mode = { "n", "v" } },
  --       { opts.mappings.line_left, desc = "move line left", mode = { "n", "v" } },
  --       { opts.mappings.line_right, desc = "move line right", mode = { "n", "v" } },
  --       { opts.mappings.line_down, desc = "move line down", mode = { "n", "v" } },
  --       { opts.mappings.line_up, desc = "move line up", mode = { "n", "v" } },
  --     }
  --     return vim.list_extend(mappings, keys)
  --   end,
  --   opts = {
  --     mappings = {
  --       -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
  --       left = "<M-n>",
  --       right = "<M-i>",
  --       down = "<M-e>",
  --       up = "<M-u>",
  --       -- Move current line in Normal mode
  --       line_left = "<M-n>",
  --       line_right = "<M-i>",
  --       line_down = "<M-e>",
  --       line_up = "<M-u>",
  --     },
  --   },
  -- },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "CursorMoved",
    opts = function()
      local colors = require("tokyonight.colors").setup()
      return {
        handle = {
          color = colors.bg_highlight,
        },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
      }
    end,
    config = function(_, opts)
      require("scrollbar").setup(opts)
      pcall(function()
        require("scrollbar.handlers.gitsigns").setup()
        require("scrollbar.handlers.search").setup({
          -- hlslens config overrides
        })
      end)
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "=", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "-", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
      { "/" },
      { "?" },
    },
  },
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    import = "saturn.plugins.lang.markdown",
    ft = { "markdown" },
  },
  {
    "mickael-menu/zk-nvim",
    ft = { "markdown", "norg" },
    opts = {
      picker = "telescope",
    },
    lsp = {
      auto_attach = {
        enabled = true,
        filetypes = { "markdown", "norg" },
      },
    },
  },
}
