-- default text-objects
return {
	{
		"echasnovski/mini.ai",
		keys = {
			{ "[f", desc = "Prev function" },
			{ "]f", desc = "Next function" },
		},
		opts = function()
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
				local desc = (down and "Next " or "Prev ")
					.. (start and "start" or "end")
					.. " of "
					.. capture:gsub("%..*", "")
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
					w = { "()()%f[%w]%w+()[ \t]*()" },
				},
				mappings = {
					inside = "h",
					inside_next = "hn",
					inside_last = "hl",
				},
			}
		end,
		config = function(_, opts)
			-- register all text objects with which-key
			if require("lazyvim.util").has("which-key.nvim") then
				---@type table<string, string|table>
				local i = {
					[" "] = "Whitespace",
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					["`"] = "Balanced `",
					["("] = "Balanced (",
					[")"] = "Balanced ) including white-space",
					[">"] = "Balanced > including white-space",
					["<lt>"] = "Balanced <",
					["]"] = "Balanced ] including white-space",
					["["] = "Balanced [",
					["}"] = "Balanced } including white-space",
					["{"] = "Balanced {",
					["?"] = "User Prompt",
					_ = "Underscore",
					a = "Argument",
					b = "Balanced ), ], }",
					c = "Class",
					f = "Function",
					o = "Block, conditional, loop",
					q = "Quote `, \", '",
					t = "Tag",
				}
				local a = vim.deepcopy(i)
				for k, v in pairs(a) do
					a[k] = v:gsub(" including.*", "")
				end

				local ic = vim.deepcopy(i)
				local ac = vim.deepcopy(a)
				for key, name in pairs({ n = "Next", l = "Last" }) do
					i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
					a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
				end
				require("which-key").register({
					mode = { "o", "x" },
					h = i,
					a = a,
					i = {},
				})
			end
		end,
	},
	{
		"echasnovski/mini.indentscope",
		opts = {
			mappings = {
				-- Textobjects
				object_scope = "hi", -- integrate with mini.ai
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = function(_, opts)
			return {
				on_attach = function(buffer)
					opts.on_attach(buffer)
					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
					end

					local function unmap(mode, key)
						vim.keymap.del(mode, key, { buffer = buffer })
					end

					unmap({ "o", "x" }, "ih")
					map({ "o", "x" }, "hh", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
				end,
			}
		end,
	},
}
