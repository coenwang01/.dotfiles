{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.neovim.lazyvim;

  pluginsOptionType = listOf (oneOf [
    package
    (submodule {
      options = {
        name = mkOption {type = str;};
        path = mkOption {type = package;};
      };
    })
  ]);
in {
  imports = [
    ./config.nix
    ./plugins
  ];

  options.my.neovim.lazyvim = {
    enable = mkEnableOption "LazyVim";

    plugins = mkOption {
      type = pluginsOptionType;
      default = with pkgs.vimPlugins; [
        LazyVim

        ##############
        # coding.lua #
        ##############

        # auto pairs
        {
          name = "mini.pairs";
          path = mini-nvim;
        }
        # comments
        ts-comments-nvim
        # Better text-objects
        {
          name = "mini.ai";
          path = mini-nvim;
        }
        lazydev-nvim

        ###################
        # colorscheme.lua #
        ###################

        tokyonight-nvim
        {
          name = "catppuccin";
          path = catppuccin-nvim;
        }

        ##############
        # editor.lua #
        ##############

        neo-tree-nvim
        grug-far-nvim
        flash-nvim
        which-key-nvim
        gitsigns-nvim
        trouble-nvim
        todo-comments-nvim

        ##################
        # formatting.lua #
        ##################

        conform-nvim

        ###############
        # linting.lua #
        ###############

        nvim-lint

        ##################
        # treesitter.lua #
        ##################

        nvim-treesitter
        nvim-treesitter-textobjects
        nvim-ts-autotag

        ##########
        # ui.lua #
        ##########

        bufferline-nvim
        lualine-nvim
        noice-nvim
        {
          name = "mini.icons";
          path = mini-nvim;
        }
        nui-nvim
        snacks-nvim

        #######
        # lsp #
        #######

        nvim-lspconfig
      ];
    };

    cmp = mkOption {
      type = types.enum ["auto" "nivm-cmp" "blink.cmp"];
      default = "auto";
      description = ''
        choose the completion engine
        if you choose "auto", it will use the lazyVim default completion engine
      '';
    };

    picker = mkOption {
      type = types.enum ["auto" "telescope" "fzf"];
      default = "auto";
      description = ''
        choose the picker engine
        if you choose "auto", it will use the lazyVim default picker engine
      '';
    };

    extraPlugins = mkOption {
      type = pluginsOptionType;
      default = [];
    };

    excludePlugins = mkOption {
      type = pluginsOptionType;
      default = [];
    };

    extraSpec = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      extraPackages = with pkgs; [
        # LazyVim
        lua
        lua-language-server
        stylua
        vscode-langservers-extracted
      ];

      plugins = with pkgs.vimPlugins; [lazy-nvim];

      extraLuaConfig = let
        mkEntryFromDrv = drv:
          if lib.isDerivation drv
          then {
            name = "${lib.getName drv}";
            path = drv;
          }
          else drv;

        lazyPath = pkgs.linkFarm "lazy-plugins" (
          builtins.map mkEntryFromDrv (lib.subtractLists cfg.excludePlugins cfg.plugins ++ cfg.extraPlugins)
        );
      in ''
        vim.g.lazyvim_cmp = "${cfg.cmp}"
        vim.g.lazyvim_picker = "${cfg.picker}"
        require("lazy").setup({
          change_detection = { notify = false },
          defaults = {
            lazy = true,
            version = false
          },
          ui = { border = "rounded" },
          dev = {
            path = "${lazyPath}",
            patterns = { "" },
            fallback = true,
          },
          checker = { enabled = false },
          rocks = {
            enabled = false,
          },
          performance = {
            cache = {
              enabled = true,
            },
            rtp = {
              disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            -- import/override with your plugins
            { import = "plugins" },
            -- treesitter handled by my.neovim.treesitterParsers, put this line at the end of spec to clear ensure_installed
            { "nvim-treesitter/nvim-treesitter", opts = function(_, opts) opts.ensure_installed = {} end },
            ${cfg.extraSpec}
          },
        })
      '';
    };

    my.neovim.treesitterParsers = [
      "jsonc"
      "regex"
    ];
  };
}
