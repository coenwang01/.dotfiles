return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-nvim-lua" },
      { "dmitmel/cmp-cmdline-history" },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup({
            formatters = {
              insert_text = require("copilot_cmp.format").remove_existing,
            },
          })
        end,
        dependencies = {
          "copilot.lua",
        },
      },
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        opts = {
          max_lines = 1000,
          max_num_results = 20,
          sort = true,
          run_on_every_keystroke = true,
          snippet_placeholder = "..",
          ignored_file_types = { -- default is not to ignore
            -- uncomment to ignore in lua:
            -- lua = true
          },
          show_prediction_strength = true,
        },
      },
    },
    config = function()
      require("saturn.plugins.coding.cmp").config()
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    keys = {
      "<leader>ap",
      "<cmd>Copilot panel<cr>",
      desc = "Copilot panel",
    },
    opts = {
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
    },
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")
      ls.config.set_config({
        history = true,
        enable_autosnippets = true,
        updateevents = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<- choiceNode", "Comment" } },
            },
          },
        },
      })

      local paths = {}
      paths[#paths + 1] = vim.fn.stdpath("data") .. "/lazy/friendly-snippets/"
      local user_snippets = vim.fn.stdpath("config") .. "/snippets"
      paths[#paths + 1] = user_snippets
      require("luasnip.loaders.from_lua").lazy_load({ paths = user_snippets })
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = paths,
      })
      require("luasnip.loaders.from_snipmate").lazy_load()
      vim.keymap.set({ "i", "s" }, "<C-n>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
      vim.keymap.set({ "i", "s" }, "<C-p>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end)
      vim.keymap.set(
        "i",
        "<M-s",
        "<cmd>lua require'luasnip.extras.select_choice'()<cr>",
        { desc = "select snippet choice" }
      )

      _G.s = ls.snippet
      _G.sn = ls.snippet_node
      _G.t = ls.text_node
      _G.i = ls.insert_node
      _G.f = ls.function_node
      _G.c = ls.choice_node
      _G.d = ls.dynamic_node
      _G.r = ls.restore_node
      _G.l = require("luasnip.extras").lambda
      _G.rep = require("luasnip.extras").rep
      _G.p = require("luasnip.extras").partial
      _G.m = require("luasnip.extras").match
      _G.n = require("luasnip.extras").nonempty
      _G.dl = require("luasnip.extras").dynamic_lambda
      _G.fmt = require("luasnip.extras.fmt").fmt
      _G.fmta = require("luasnip.extras.fmt").fmta
      _G.types = require("luasnip.util.types")
      _G.conds = require("luasnip.extras.conditions")
      _G.conds_expand = require("luasnip.extras.conditions.expand")
    end,
    event = "InsertCharPre",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  -- surround
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sl", -- Update `n_lines`
        suffix_last = "u", -- Suffix to search with "prev" method
        suffix_next = "e", -- Suffix to search with "next" method
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },

  -- Comment
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "echasnovski/mini.comment",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.comment"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.comment, mode = { "n", "x" } },
        { opts.mappings.comment_line },
        { opts.mappings.textobject },
        { "<leader>/", opts.mappings.comment_line, remap = true },
        { "<leader>/", opts.mappings.comment, mode = "x", remap = true },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        textobject = "gc",
      },
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    keys = {
      { "[f", desc = "Prev function" },
      { "]f", desc = "Next function" },
      { "a", mode = { "x", "o" } },
      { "k", mode = { "x", "o" } },
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
    },
    opts = function()
      local ai = require("mini.ai")

      -- add treesitter jumping
      ---@param capture string
      ---@param start boolean
      ---@param down boolean
      local function jump(capture, start, down)
        local rhs = function()
          local parser = vim.treesitter.get_parser()
          if not parser then
            return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
          end

          local query = vim.treesitter.get_query(vim.bo.filetype, "textobjects")
          if not query then
            return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
          end

          local cursor = vim.api.nvim_win_get_cursor(0)

          ---@type {[1]:number, [2]:number}[]
          local locs = {}
          for _, tree in ipairs(parser:trees()) do
            for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
              if query.captures[capture_id] == capture then
                local range = { node:range() } ---@type number[]
                local row = (start and range[1] or range[3]) + 1
                local col = (start and range[2] or range[4]) + 1
                if down and row > cursor[1] or (not down) and row < cursor[1] then
                  table.insert(locs, { row, col })
                end
              end
            end
          end
          return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
        end

        local c = capture:sub(1, 1):lower()
        local lhs = (down and "]" or "[") .. (start and c or c:upper())
        local desc = (down and "Next " or "Prev ") .. (start and "start" or "end") .. " of " .. capture:gsub("%..*", "")
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      for _, capture in ipairs({ "function.outer", "class.outer" }) do
        for _, start in ipairs({ true, false }) do
          for _, down in ipairs({ true, false }) do
            jump(capture, start, down)
          end
        end
      end
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require("mini.ai")
      ai.setup(opts)
      --HACK: use k as inside
      vim.api.nvim_set_keymap(
        "x",
        "k",
        [[v:lua.require("mini.ai").expr_textobject('x', 'i')]],
        { desc = "Inside textobject", expr = true, noremap = false }
      )
      vim.api.nvim_set_keymap(
        "o",
        "k",
        [[v:lua.require("mini.ai").expr_textobject('o', 'i')]],
        { desc = "Inside textobject", expr = true, noremap = false }
      )
      vim.keymap.set("v", "i", "l")
      -- register all text objects with which-key
      -- if require("saturn.utils.plugin").has("which-key.nvim") then
      --   ---@type table<string, string|table>
      --   local i = {
      --     [" "] = "Whitespace",
      --     ['"'] = 'Balanced "',
      --     ["'"] = "Balanced '",
      --     ["`"] = "Balanced `",
      --     ["("] = "Balanced (",
      --     [")"] = "Balanced ) including white-space",
      --     [">"] = "Balanced > including white-space",
      --     ["<lt>"] = "Balanced <",
      --     ["]"] = "Balanced ] including white-space",
      --     ["["] = "Balanced [",
      --     ["}"] = "Balanced } including white-space",
      --     ["{"] = "Balanced {",
      --     ["?"] = "User Prompt",
      --     _ = "Underscore",
      --     a = "Argument",
      --     b = "Balanced ), ], }",
      --     c = "Class",
      --     f = "Function",
      --     o = "Block, conditional, loop",
      --     q = "Quote `, \", '",
      --     t = "Tag",
      --   }
      --   local a = vim.deepcopy(i)
      --   for k, v in pairs(a) do
      --     a[k] = v:gsub(" including.*", "")
      --   end
      --
      --   local ic = vim.deepcopy(i)
      --   local ac = vim.deepcopy(a)
      --   for key, name in pairs({ n = "Next", l = "Last" }) do
      --     i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
      --     a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
      --   end
      --   require("which-key").register({
      --     mode = { "o", "x" },
      --     k = i,
      --     a = a,
      --   })
      -- end
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
      {
        "<leader>rb",
        function()
          require("refactoring").refactor("Extract Block")
        end,
        mode = "n",
        noremap = true,
        silent = true,
        expr = false,
      },
      {
        "<leader>rB",
        function()
          require("refactoring").refactor("Extract Block To File")
        end,
        mode = "n",
        noremap = true,
        silent = true,
        expr = false,
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor("Inline Variable")
        end,
        mode = "n",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    config = true,
  },
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
    dependencies = { "nvim-treesitter" },
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-=>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-->", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },

  -- better yank/paste
  {
    "kkharji/sqlite.lua",
    enabled = function()
      return not jit.os:find("Windows")
    end,
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "y", "<Plug>(YankyYank)", desc = "Yank", mode = { "n", "x" } },
      { "p", "<Plug>(YankyPutAfter)", desc = "Yank put after", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", desc = "Yanky put before", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", desc = "Yanky Gput after", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", desc = "Yanky Gput before", mode = { "n", "x" } },
      { "<c-[>", "<Plug>(YankyCycleForward)", desc = "Yanky Cycle Forward" },
      { "<c-]>", "<Plug>(YankyCycleBackward)", desc = "Yanky Cycle Backward" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yank put indent after linewise" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yank put indent before linewise" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yank put indent after linewise" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yank put indent before linewise" },
      {
        "<leader>P",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Paste from Yanky",
      },
    },
    config = function()
      -- vim.g.clipboard = {
      --   name = "xsel_override",
      --   copy = {
      --     ["+"] = "xsel --input --clipboard",
      --     ["*"] = "xsel --input --primary",
      --   },
      --   paste = {
      --     ["+"] = "xsel --output --clipboard",
      --     ["*"] = "xsel --output --primary",
      --   },
      --   cache_enabled = 1,
      -- }

      require("yanky").setup({
        highlight = {
          timer = 150,
        },
        ring = {
          storage = jit.os:find("Windows") and "shada" or "sqlite",
        },
      })
    end,
  },
  -- {
  --   "dense-analysis/neural",
  --   cmd = "NeuralCode",
  --   dependencies = "MunifTanjim/nui.nvim",
  --   config = function()
  --     require("neural").setup({
  --       mappings = {
  --         swift = nil,
  --         prompt = nil,
  --       },
  --       open_ai = {
  --         api_key = vim.env.OPENAI_API_KEY, -- not committed, defined in config/private-settings.lua outside of repo
  --         max_tokens = 1000,
  --         temperature = 0.1,
  --         presence_penalty = 0.5,
  --         frequency_penalty = 0.5,
  --       },
  --       ui = { icon = saturn.icons.misc.Robot },
  --     })
  --   end,
  -- },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   cmd = {
  --     "ChatGPT",
  --     "ChatGPTActAs",
  --     "ChatGPTEditWithInstructions",
  --   },
  --   opts = {
  --     keymaps = {
  --       close = { "<C-c>", "<Esc>" },
  --       yank_last = "<C-y>",
  --       scroll_up = "<C-u>",
  --       scroll_down = "<C-e>",
  --       toggle_settings = "<C-o>",
  --       new_session = "<C-n>",
  --       cycle_windows = "<Tab>",
  --     },
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  -- {
  --   "MattesGroeger/vim-bookmarks",
  --   config = true,
  --   keys = {
  --     { "<leader>ma", "<cmd>silent BookmarkAnnotate<cr>", desc = "Annotate" },
  --     { "<leader>mc", "<cmd>silent BookmarkClear<cr>", desc = "Clear" },
  --     { "<leader>mt", "<cmd>silent BookmarkToggle<cr>", desc = "Toggle" },
  --     { "<leader>me", "<cmd>silent BookmarkNext<cr>", desc = "Next" },
  --     { "<leader>mu", "<cmd>silent BookmarkPrev<cr>", desc = "Prev" },
  --     { "<leader>ml", "<cmd>silent BookmarkShowAll<cr>", desc = "Show All" },
  --     { "<leader>mx", "<cmd>BookmarkClearAll<cr>", desc = "Clear All" },
  --   },
  --   cmd = {
  --     "BookmarkToggle",
  --     "BookmarkAnnotate",
  --     "BookmarkNext",
  --     "BookmarkPrev",
  --     "BookmarkShowAll",
  --     "BookmarkClear",
  --     "BookmarkClearAll",
  --     "BookmarkMoveUp",
  --     "BookmarkMoveDown",
  --     "BookmarkMoveToLine",
  --     "BookmarkSave",
  --     "BookmarkLoad",
  --   },
  -- },
}