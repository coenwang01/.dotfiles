-- require("luasnip/loaders/from_vscode").lazy_load()
local M = {
  "hrsh7th/nvim-cmp",
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
  },
}

M.enabled = function()
  local buftype = vim.api.nvim_buf_get_option(0, "buftype")
  if buftype == "prompt" then
    return false
  end
  return true
end

M.methods = {}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
M.methods.has_words_before = has_words_before

local T = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function feedkeys(key, mode)
  vim.api.nvim_feedkeys(T(key), mode, true)
end

M.methods.feedkeys = feedkeys

---when inside a snippet, seeks to the nearest luasnip field if possible, and checks if it is jumpable
---@param dir number 1 for forward, -1 for backward; defaults to 1
---@return boolean true if a jumpable luasnip field is found while inside a snippet
local function jumpable(dir)
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_ok then
    return false
  end

  local win_get_cursor = vim.api.nvim_win_get_cursor
  local get_current_buf = vim.api.nvim_get_current_buf

  ---sets the current buffer's luasnip to the one nearest the cursor
  ---@return boolean true if a node is found, false otherwise
  local function seek_luasnip_cursor_node()
    -- TODO(kylo252): upstream this
    -- for outdated versions of luasnip
    if not luasnip.session.current_nodes then
      return false
    end

    local node = luasnip.session.current_nodes[get_current_buf()]
    if not node then
      return false
    end

    local snippet = node.parent.snippet
    local exit_node = snippet.insert_nodes[0]

    local pos = win_get_cursor(0)
    pos[1] = pos[1] - 1

    -- exit early if we're past the exit node
    if exit_node then
      local exit_pos_end = exit_node.mark:pos_end()
      if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end
    end

    node = snippet.inner_first:jump_into(1, true)
    while node ~= nil and node.next ~= nil and node ~= snippet do
      local n_next = node.next
      local next_pos = n_next and n_next.mark:pos_begin()
      local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
        or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

      -- Past unmarked exit node, exit early
      if n_next == nil or n_next == snippet.next then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end

      if candidate then
        luasnip.session.current_nodes[get_current_buf()] = node
        return true
      end

      local ok
      ok, node = pcall(node.jump_from, node, 1, true) -- no_move until last stop
      if not ok then
        snippet:remove_from_jumplist()
        luasnip.session.current_nodes[get_current_buf()] = nil

        return false
      end
    end

    -- No candidate, but have an exit node
    if exit_node then
      -- to jump to the exit node, seek to snippet
      luasnip.session.current_nodes[get_current_buf()] = snippet
      return true
    end

    -- No exit node, exit from snippet
    snippet:remove_from_jumplist()
    luasnip.session.current_nodes[get_current_buf()] = nil
    return false
  end

  if dir == -1 then
    return luasnip.in_snippet() and luasnip.jumpable(-1)
  else
    return luasnip.in_snippet() and seek_luasnip_cursor_node() and luasnip.jumpable(1)
  end
end

M.methods.jumpable = jumpable


M.init = function()
  local status_cmp_ok, cmp = pcall(require, "cmp")
  if not status_cmp_ok then
    return
  end
  local status_luaship_ok, luasnip = pcall(require, "luasnip")
  if not status_luaship_ok then
    return
  end
  saturn.plugins.cmp = {
    on_config_done = nil,
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    completion = {
      ---@usage The minimum length of a word to complete on.
      keyword_length = 1,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      max_width = 0,
      kind_icons = saturn.icons.kind,
      source_names = {
        nvim_lsp = "(LSP)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        cmp_tabnine = "(Tabnine)",
        vsnip = "(Snippet)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
        tmux = "(TMUX)",
        copilot = "(Copilot)",
        treesitter = "(TreeSitter)",
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
      duplicates_default = 0,
      format = function(entry, vim_item)
        local max_width = saturn.plugins.cmp.formatting.max_width
        if max_width ~= 0 and #vim_item.abbr > max_width then
          vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. saturn.icons.ui.Ellipsis
        end
        if saturn.use_icons then
          vim_item.kind = saturn.plugins.cmp.formatting.kind_icons[vim_item.kind]

          -- TODO: not sure why I can't put this anywhere else
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
          if entry.source.name == "copilot" then
            vim_item.kind = saturn.icons.git.Octoface
            vim_item.kind_hl_group = "CmpItemKindCopilot"
          end

          vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
          if entry.source.name == "cmp_tabnine" then
            vim_item.kind = saturn.icons.misc.Robot
            vim_item.kind_hl_group = "CmpItemKindTabnine"
          end

          vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
          if entry.source.name == "crates" then
            vim_item.kind = saturn.icons.misc.Package
            vim_item.kind_hl_group = "CmpItemKindCrate"
          end

          if entry.source.name == "lab.quick_data" then
            vim_item.kind = saturn.icons.misc.CircuitBoard
            vim_item.kind_hl_group = "CmpItemKindConstant"
          end

          vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
          if entry.source.name == "emoji" then
            vim_item.kind = saturn.icons.misc.Smiley
            vim_item.kind_hl_group = "CmpItemKindEmoji"
          end
        end
        vim_item.menu = saturn.plugins.cmp.formatting.source_names[entry.source.name]
        vim_item.dup = saturn.plugins.cmp.formatting.duplicates[entry.source.name]
          or saturn.plugins.cmp.formatting.duplicates_default
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = {
      {
        name = "copilot",
        -- keyword_length = 0,
        max_item_count = 3,
        trigger_characters = {
          {
            ".",
            ":",
            "(",
            "'",
            '"',
            "[",
            ",",
            "#",
            "*",
            "@",
            "|",
            "=",
            "-",
            "{",
            "/",
            "\\",
            "+",
            "?",
            " ",
            -- "\t",
            -- "\n",
          },
        },
        group_index = 2,
      },
      {
        name = "nvim_lsp",
        entry_filter = function(entry, ctx)
          local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return false
          end
          if kind == "Text" then
            return false
          end
          return true
        end,
        group_index = 2,
      },

      { name = "path", group_index = 2 },
      { name = "luasnip", group_index = 2 },
      { name = "cmp_tabnine", group_index = 2 },
      { name = "nvim_lua", group_index = 2 },
      { name = "buffer", group_index = 2 },
      { name = "calc", group_index = 2 },
      { name = "emoji", group_index = 2 },
      { name = "treesitter", group_index = 2 },
      { name = "crates", group_index = 2 },
      { name = "tmux", group_index = 2 },
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-u>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-y>"] = cmp.mapping({
        i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end,
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif jumpable(1) then
          luasnip.jump(1)
        elseif has_words_before() then
          -- cmp.complete()
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-c>"] = cmp.mapping.complete(),
      ["<C-x>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local confirm_opts = vim.deepcopy(saturn.plugins.cmp.confirm_opts) -- avoid mutating the original opts below
          local is_insert_mode = function()
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then -- prevent overwriting brackets
            confirm_opts.behavior = cmp.ConfirmBehavior.Insert
          end
          if cmp.confirm(confirm_opts) then
            return -- success, exit early
          end
        end
        fallback() -- if not exited early, always fallback
      end),
    }),
    -- sorting = {
    --   priority_weight = 2,
    --   comparators = {
    --     require("copilot-cmp.comparators").prioritize,
    --     require("copilot-cmp.comparators").score,
    --
    --     -- Below is the default comparitor list and order for nvim-cmp
    --     cmp.config.compare.offset,
    --     -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
    --     cmp.config.compare.exact,
    --     cmp.config.compare.score,
    --     cmp.config.compare.recently_used,
    --     cmp.config.compare.locality,
    --     cmp.config.compare.kind,
    --     cmp.config.compare.sort_text,
    --     cmp.config.compare.length,
    --     cmp.config.compare.order,
    --   },
    -- },
    cmdline = {
      enable = true,
      options = {
        {
          type = ":",
          sources = {
            { name = "path" },
            { name = "cmdline" },
          },
        },
        {
          type = { "/", "?" },
          sources = {
            { name = "buffer" },
          },
        },
      },
    },
  }
end

function M.config()
  if saturn.plugins.cmp == nil then
    return
  end
  local cmp = require("cmp")
  cmp.setup(saturn.plugins.cmp)

  if saturn.plugins.cmp.cmdline.enable then
    for _, option in ipairs(saturn.plugins.cmp.cmdline.options) do
      cmp.setup.cmdline(option.type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = option.sources,
      })
    end
  end

  if saturn.plugins.cmp.on_config_done then
    saturn.plugins.cmp.on_config_done(cmp)
  end
end

return M
