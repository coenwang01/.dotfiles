-- default comment
return {
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
				{ "<c-/>", opts.mappings.comment_line, remap = true },
				{ "<c-/>", opts.mappings.comment, mode = "x", remap = true },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				comment = "gc",
				comment_line = "gcc",
				textobject = "gc",
			},
		},
	},
}