return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      },
    },
    keys = {
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-e>"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["<C-i>"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["<C-v>"] = function(...)
              return require("telescope.actions").select_vertical(...)
            end,
            ["<C-h>"] = function(...)
              return require("telescope.actions").select_horizontal(...)
            end,
            ["<C-s>"] = function(...)
              return require("telescope.actions").select_tab(...)
            end,
          },
          n = {
            ["e"] = function(...)
              return require("telescope.actions").move_selection_next(...)
            end,
            ["i"] = function(...)
              return require("telescope.actions").move_selection_previous(...)
            end,
            ["j"] = nil,
            ["k"] = nil,
            ["h"] = function(...)
              return require("telescope.actions").select_horizontal(...)
            end,
            ["v"] = function(...)
              return require("telescope.actions").select_vertical(...)
            end,
            ["s"] = function(...)
              return require("telescope.actions").select_tab(...)
            end,
          },
        },
      },
    },
  },
}
