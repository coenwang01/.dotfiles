return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "markdown" },
    keys = {
      {
        "<leader><space>",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "light" },
  },
  {
    "renerocksai/telekasten.nvim",
    dependencies = {
      {
        "renerocksai/calendar-vim",
        keys = {
          { "<leader>nC", "<cmd>CalendarT<cr>", desc = "Calendar" },
        },
      },
    },
    cmd = { "Telekasten" },
    ft = { "markdown" },
    keys = {
      {
        "<leader>nf",
        function()
          require("telekasten").find_notes()
        end,
        desc = "find notes",
      },
      {
        "<leader>nd",
        function()
          require("telekasten").find_daily_notes()
        end,
        desc = "find daily_notes",
      },
      {
        "<leader>ns",
        function()
          require("telekasten").search_notes()
        end,
        desc = "search note",
      },
      {
        "<leader>nl",
        function()
          require("telekasten").follow_link()
        end,
        desc = "follow link",
      },
      {
        "<leader>nT",
        function()
          require("telekasten").goto_today()
        end,
        desc = "goto today",
      },
      {
        "<leader>nW",
        function()
          require("telekasten").goto_thisweek()
        end,
        desc = "goto this week",
      },
      {
        "<leader>nw",
        function()
          require("telekasten").find_weekly_notes()
        end,
        desc = "find weekly notes",
      },
      {
        "<leader>nn",
        function()
          require("telekasten").new_note()
        end,
        desc = "new note",
      },
      {
        "<leader>nN",
        function()
          require("telekasten").new_templated_note()
        end,
        desc = "new templated notes",
      },
      {
        "<leader>ny",
        function()
          require("telekasten").yank_notelink()
        end,
        desc = "yank notelink",
      },
      {
        "<leader>nc",
        function()
          require("telekasten").show_calendar()
        end,
        desc = "show calendar",
      },
      {
        "<leader>ni",
        function()
          require("telekasten").paste_img_and_link()
        end,
        desc = "paste image and link",
      },
      {
        "<leader>nt",
        function()
          require("telekasten").toggle_todo()
        end,
        desc = "toggle todo",
      },
      {
        "<leader>nb",
        function()
          require("telekasten").show_backlinks()
        end,
        desc = "show backlinks",
      },
      {
        "<leader>nF",
        function()
          require("telekasten").find_friends()
        end,
        desc = "find friends",
      },
      {
        "<leader>nI",
        function()
          require("telekasten").insert_img_link()
        end,
        desc = "insert image link",
      },
      {
        "<leader>np",
        function()
          require("telekasten").preview_img()
        end,
        desc = "preview image",
      },
      {
        "<leader>nm",
        function()
          require("telekasten").browse_media()
        end,
        desc = "browse media",
      },
      {
        "<leader>na",
        function()
          require("telekasten").show_tags()
        end,
        desc = "show tags",
      },
      {
        "<leader>#",
        function()
          require("telekasten").show_tags()
        end,
        desc = "show tags",
      },
      {
        "<leader>nr",
        function()
          require("telekasten").rename_note()
        end,
        desc = "rename note",
      },
      {
        "<leader>n<cr>",
        function()
          require("telekasten").panel()
        end,
        desc = "telekasten panel",
      },
      {
        "<leader>ni",
        function()
          require("telekasten").insert_link({ i = true })
        end,
        desc = "insert link",
        mode = "i",
      },
      {
        "<leader>nt",
        function()
          require("telekasten").toggle_todo({ i = true })
        end,
        desc = "toggle todo",
        mode = "i",
      },
      {
        "<leader>#",
        function()
          require("telekasten").show_tags({ i = true })
        end,
        desc = "show tags",
        mode = "i",
      },
    },
    opts = function()
      local home = vim.fn.expand("~/Notes")
      return {
        home = home,
        take_over_my_home = true,
        auto_set_filetype = true,
        auto_set_syntax = true,
        dailies = home .. "/" .. "journal",
        templates = home .. "/" .. "templates",
        image_subdir = "images",
        extension = ".md",
        new_note_filename = "title",
        uuid_type = "%Y-%m-%d",
        uuid_sep = "-",
        follow_creates_nonexisting = false,
        dailies_create_nonexisting = false,
        weeklies_create_nonexisting = false,
        journal_auto_open = false,
        template_new_note = nil,
        template_new_daily = nil,
        template_new_weekly = nil,
        image_link_style = "markdown",
        sort = "filename",
        plug_into_calendar = true,
        calendar_opts = {
          weeknm = 4,
          calendar_monday = 1,
          calendar_mark = "left-fit",
        },

        close_after_yanking = false,
        insert_after_inserting = true,

        tag_notation = "#tag",

        command_palette_theme = "dropdown",

        show_tags_theme = "ivy",

        subdirs_in_links = true,

        template_handling = "same_as_current",

        new_note_location = "smart",

        rename_update_links = true,

        media_previewer = "telescope-media-files",

        follow_url_fallback = nil,
      }
    end,
  },
  -- {
  --   "mickael-menu/zk-nvim",
  --   ft = { "markdown", "norg" },
  --   opts = {
  --     picker = "telescope",
  --   },
  --   lsp = {
  --     auto_attach = {
  --       enabled = true,
  --       filetypes = { "markdown", "norg" },
  --     },
  --   },
  -- },
  {
    "christianchiarulli/rust-tools.nvim",
    branch = "modularize_and_inlay_rewrite",
    ft = "rust",
    config = function()
      local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
      local codelldb_adapter = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_path .. "bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      require("rust-tools").setup({
        tools = {
          executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
          reload_workspace_from_cargo_toml = true,
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = false,
            only_current_line = false,
            show_parameter_hints = false,
            parameter_hints_prefix = "<-",
            other_hints_prefix = "=>",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          hover_actions = {
            border = "rounded",
          },
          on_initialized = function()
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
              pattern = { "*.rs" },
              callback = function()
                local _, _ = pcall(vim.lsp.codelens.refresh)
              end,
            })
          end,
        },
        dap = {
          adapter = codelldb_adapter,
        },
        server = {
          on_attach = function(client, bufnr)
            require("saturn.plugins.lsp.hooks").common_on_attach(client, bufnr)
            local rt = require("rust-tools")
            vim.keymap.set("n", "H", rt.hover_actions.hover_actions, { buffer = bufnr })
          end,

          capabilities = require("saturn.plugins.lsp.hooks").common_capabilities(),
          settings = {
            ["rust-analyzer"] = {
              lens = {
                enable = true,
              },
              checkOnSave = {
                enable = true,
                command = "clippy",
              },
            },
          },
        },
      })
    end,
  },
  {
    "Saecki/crates.nvim",
    version = "v0.3.0",
    dependencies = { "plenary.nvim" },
    ft = { "rust", "toml" },
    opts = {
      popup = {
        border = "rounded",
      },
      null_ls = {
        enable = true,
        name = "crates.nvim",
      },
    },
  },
}
