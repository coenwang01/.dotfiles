return {
  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = true,
  },

  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
      end
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust-analyzer", "taplo" })
      end
    end,
  },

  -- correctly setup mason dap extensions
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "codelldb" })
      end
    end,
  },

  {
    "simrat39/rust-tools.nvim",
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    optional = true,
    -- dependencies =
    opts = {
      -- make sure mason installs the server
      setup = {
        rust_analyzer = function(_, opts)
          require("util").on_lsp_lazy("rust", function()
            require("lazyvim.util").on_attach(function(client, buffer)
                -- stylua: ignore
                if client.name == "rust_analyzer" then
                  vim.keymap.set("n", "I", "<CMD>RustHoverActions<CR>", { buffer = buffer })
                  vim.keymap.set("n", "<leader>ct", "<CMD>RustDebuggables<CR>", { buffer = buffer, desc = "Run Test" })
                end
            end)
            local mason_registry = require("mason-registry")
            local rust_tools_opts = {
              tools = {
                hover_actions = {
                  auto_focus = false,
                  border = "rounded",
                },
                inlay_hints = {
                  auto = false,
                  show_parameter_hints = true,
                },
              },
              server = vim.tbl_deep_extend("force", opts, {
                settings = {
                  ["rust-analyzer"] = {
                    cargo = {
                      features = "all",
                    },
                    -- Add clippy lints for Rust.
                    checkOnSave = true,
                    check = {
                      command = "clippy",
                      features = "all",
                    },
                    procMacro = {
                      enable = true,
                    },
                  },
                },
              }),
            }
            local rust_tools = require("rust-tools")
            if mason_registry.has_package("codelldb") then
              -- rust tools configuration for debugging support
              local codelldb = mason_registry.get_package("codelldb")
              local extension_path = codelldb:get_install_path() .. "/extension/"
              local codelldb_path = extension_path .. "adapter/codelldb"
              local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
                or extension_path .. "lldb/lib/liblldb.so"
              rust_tools_opts = vim.tbl_deep_extend("force", rust_tools_opts, {
                dap = {
                  adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                },
              })
            end
            rust_tools.setup(rust_tools_opts)
            return true
          end)
        end,
        taplo = function(_, _)
          vim.api.nvim_create_autocmd({ "FileType" }, {
            pattern = "toml",
            callback = function()
              local crates = require("crates")
              local function show_documentation()
                if vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
                  crates.show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end
              require("lazyvim.util").on_attach(function(client, buffer)
                -- stylua: ignore
                if client.name == "taplo" then
                  vim.keymap.set("n", "I", show_documentation, { buffer = buffer })
                end
              end)
              return false -- make sure the base implementation calls taplo.setup
            end,
          })
        end,
      },
    },
  },

  -- neotest setup
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {
          -- Here we can set options for neotest-rust, e.g.
          -- args = { "-tags=integration" }
          dap_adapter = "lldb",
        },
      },
    },
  },
}
