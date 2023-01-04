local M = {
  "s1n7ax/nvim-window-picker",
  version = "v1.*",
  enabled = saturn.enable_extra_plugins,
}

M.init = function()
  saturn.plugins.whichkey.mappings["w"]["w"] = {
    function()
      local picker = require("window-picker")
      local picked_window_id = picker.pick_window({
        include_current_win = true,
      }) or vim.api.nvim_get_current_win()
      vim.api.nvim_set_current_win(picked_window_id)
    end,
    "Pick a window",
  }
  saturn.plugins.whichkey.mappings["w"]["s"] = {
    function()
      local picker = require("window-picker")
      local window = picker.pick_window({
        include_current_win = false,
      })
      local target_buffer = vim.fn.winbufnr(window)
      -- Set the target window to contain current buffer
      vim.api.nvim_win_set_buf(window, 0)
      -- Set current window to contain target buffer
      vim.api.nvim_win_set_buf(0, target_buffer)
    end,
    "Swap windows",
  }
end

M.config = function()
  saturn.plugins.window_picker = {
    -- when there is only one window available to pick from, use that window
    -- without prompting the user to select
    autoselect_one = true,

    -- whether you want to include the window you are currently on to window
    -- selection or not
    include_current_win = false,

    -- when you go to window selection mode, status bar will show one of
    -- following letters on them so you can use that letter to select the window
    selection_chars = "TNSERIAOCMPLFUWYQ;",

    -- whether you want to use winbar instead of the statusline
    -- "always" means to always use winbar,
    -- "never" means to never use winbar
    -- "smart" means to use winbar if cmdheight=0 and statusline if cmdheight > 0
    use_winbar = "never", -- "always" | "never" | "smart"

    -- if you want to manually filter out the windows, pass in a function that
    -- takes two parameters. you should return window ids that should be
    -- included in the selection
    -- EX:-
    -- function(window_ids, filters)
    --    -- filter the window_ids
    --    -- return only the ones you want to include
    --    return {1000, 1001}
    -- end
    filter_func = nil,

    -- following filters are only applied when you are using the default filter
    -- defined by this plugin. if you pass in a function to "filter_func"
    -- property, you are on your own
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = { "NvimTree", "neo-tree", "notify" },

        -- if the buffer type is one of following, the window will be ignored
        buftype = { "terminal" },
      },

      -- filter using window options
      wo = {},

      -- if the file path contains one of following names, the window
      -- will be ignored
      file_path_contains = {},

      -- if the file name contains one of following names, the window will be
      -- ignored
      file_name_contains = {},
    },

    -- the foreground (text) color of the picker
    fg_color = "#ededed",

    -- if you have include_current_win == true, then current_win_hl_color will
    -- be highlighted using this background color
    current_win_hl_color = "#e35e4f",

    -- all the windows except the curren window will be highlighted using this
    -- color
    other_win_hl_color = "#44cc41",

    -- You can change the display string in status bar.
    -- It supports '%' printf style. Such as `return char .. ': %f'` to display
    -- buffer filepath. See :h 'stl' for details.
    selection_display = function(char)
      return char
    end,
  }

  require("window-picker").setup(saturn.plugins.window_picker)
end

return M