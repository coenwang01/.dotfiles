return {
  {
    "nvim-neorg/neorg",
    ft = "norg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        -- ["core.norg.completion"] = {
        --   config = { engine = "nvim-cmp" },
        -- },
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Notes",
            },
            index = "index.norg",
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = ",",
          },
        },
        -- ["core.integrations.nvim-cmp"] = {},
        -- ["core.integrations.telescope"] = {},
      },
    },
    -- dependencies = { { "nvim-lua/plenary.nvim" }, { "telescope.nvim" }, { "nvim-neorg/neorg-telescope" } },
  },
}
