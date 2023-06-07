--          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- Command        +------+-----+-----+-----+-----+-----+------+------+
-- [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
local map = vim.keymap.set
local unmap = vim.keymap.del
local Util = require("lazyvim.util")
unmap("n", "<C-h>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-l>")
-- local map = vim.keymap.set
-- local Util = require("lazyvim.util")
-- colemak-dh movement
map({ "n", "x", "o" }, "e", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x", "o" }, "i", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x", "o" }, "n", "h")
map({ "n", "x", "o" }, "o", "l")

-- colemak-dh jump to start/end of the line
map({ "n", "x", "o" }, "N", "^")
map({ "n", "x", "o" }, "O", "$")

-- colemak-dh join/hover
map({ "n", "x", "o" }, "I", "K")
-- if not Util.has("treesj") or not Util.has("mini.splitjoin") then
-- 	map({ "n", "x", "o" }, "E", "J")
-- end

-- colemak-dh insert key
map({ "n", "x", "o" }, "h", "i")
map({ "n", "x", "o" }, "H", "I")
map({ "n", "x", "o" }, "gh", "gi", { desc = "goto last insert" })
map({ "n", "x", "o" }, "gH", "gI", { desc = "goto start of last insert line" })

-- colemake-dh undo key
map({ "n", "x", "o" }, "l", "o")
map({ "n", "x", "o" }, "L", "O")

-- colemak-dh end of word
map({ "n", "x", "o" }, "j", "e")
map({ "n", "x", "o" }, "J", "E")
map({ "n", "x", "o" }, "gj", "ge")
map({ "n", "x", "o" }, "gJ", "gE")

-- colemake searching key
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "k", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "K", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map({ "n", "x", "o" }, "gk", "gn", { desc = "Search forwards and select" })
map({ "n", "x", "o" }, "gK", "gN", { desc = "Search backwards and select" })

-- colemak scroll
map({ "n", "v" }, "<C-m>", "<C-e>")

-- emacs kill a line
map("i", "<C-k>", "<cmd>normal! dd<cr>")

-- better cmd mode
map("n", ":", ",")
map("n", "<cr>", ":")
-- backup cmd mode, some plugins will override <cr>
map("n", "\\", ":")

-- save
-- map("n", "S", "<cmd>w<cr>", { desc = "Save file" })

-- select all
map({ "n", "x", "i" }, "<C-a>", "<cmd>normal! ggVG<cr>")

-- new space line
map("n", "<C-cr>", "<cmd>normal! o<cr>")

-- paste
map("i", "<C-v>", "<C-g>u<Cmd>set paste<CR><C-r>+<Cmd>set nopaste<CR>")
map("t", "<C-v>", "<C-\\><C-N>pi")
map("c", "<C-v>", "<C-r>+")

-- inc/dec number
map("n", "<C-=>", "<C-a>")
map("n", "<C-->", "<C-x>")

-- Column inc/dec numbers
map("v", "g<C-=>", "g<C-a>")
map("v", "g<C-->", "g<C-x>")

-- better indentation
map("n", "<", "<<")
map("n", ">", ">>")

-- Better Copy
map("n", "Y", "y$")
map("v", "Y", '"+y')

-- Move lines
map("n", "<A-e>", ":m .+1<CR>==")
map("v", "<A-e>", ":m '>+1<CR>gv=gv")
map("i", "<A-e>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-i>", ":m .-2<CR>==")
map("v", "<A-i>", ":m '<-2<CR>gv=gv")
map("i", "<A-i>", "<Esc>:m .-2<CR>==gi")

-- insert mode navigation
map("i", "<A-Up>", "<C-\\><C-N><C-w>k")
map("i", "<A-Down>", "<C-\\><C-N><C-w>j")
map("i", "<A-Left>", "<C-\\><C-N><C-w>h")
map("i", "<A-Right>", "<C-\\><C-N><C-w>l")

-- Terminal window navigation
map("t", "<C-n>", "<C-\\><C-N><C-w>h", { desc = "move to left" })
map("t", "<C-e>", "<C-\\><C-N><C-w>j", { desc = "move to down" })
map("t", "<C-i>", "<C-\\><C-N><C-w>k", { desc = "move to up" })
map("t", "<C-o>", "<C-\\><C-N><C-w>l", { desc = "move to right" })
map("t", "<C-q>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- map tab to tab, because distinguish between <C-i>
map("t", "<Tab>", "<Tab>")

-- navigate tab completion with <c-e> and <c-j>
-- runs conditionally
map("c", "<C-e>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("c", "<C-i>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

-- colemak goto new position in jumplist
map("n", "<C-,>", "<C-i>")
map("n", "<C-.>", "<C-o>")

-- Windows managenment
--Better window movement
map("n", "<C-w>", "<C-w>w", { desc = "Switch window" })
map("n", "<C-n>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-e>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-i>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-o>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-l>", "<C-w>o", { desc = "Clear other windwos" })
map("n", "<C-q>", "<C-w>q", { desc = "Quit window" })

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- disable the default s key
map({ "n", "x" }, "s", "<nop>", { desc = "split/surround/select" })

-- split the screens
map("n", "si", function()
	vim.opt.splitbelow = false
	vim.cmd([[split]])
	vim.opt.splitbelow = true
end, { desc = "split above" })
map("n", "se", function()
	vim.opt.splitbelow = true
	vim.cmd([[split]])
end, { desc = "split below" })
map("n", "sn", function()
	vim.opt.splitright = false
	vim.cmd([[vsplit]])
end, { desc = "split left" })
map("n", "so", function()
	vim.opt.splitright = true
	vim.cmd([[vsplit]])
end, { desc = "split right" })

unmap("n", "<leader>w-")
unmap("n", "<leader>w|")
unmap("n", "<leader>-")
unmap("n", "<leader>|")
-- Rotate window
map("n", "<leader>wI", "<C-w>b<C-w>K", { desc = "rotate window up" })
map("n", "<leader>wN", "<C-w>b<C-w>H", { desc = "rotate window left" })

-- move current windwo to the far left, bottom, right, top
map("n", "<leader>wn", "<C-w>H", { desc = "move to the far left" })
map("n", "<leader>we", "<C-w>J", { desc = "move to the far bottom" })
map("n", "<leader>wo", "<C-w>L", { desc = "move to the far right" })
map("n", "<leader>wi", "<C-w>K", { desc = "move to the far top" })

-- Switch buffer with tab
map("n", "<tab>", "<cmd>bnext<cr>")
map("n", "<s-tab>", "<cmd>bprevious<cr>")

-- Tabs management
unmap("n", "<leader><tab>]")
unmap("n", "<leader><tab>[")
map("n", "]<tab>", "<cmd>tabn<CR>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabp<CR>", { desc = "Prev Tab" })
map("n", "<leader><tab>s", "<cmd>tab split<CR>", { desc = "Split" })
map("n", "<leader><tab>]", "<cmd>-tabmove<CR>", { desc = "Move to left" })
map("n", "<leader><tab>[", "<cmd>+tabmove<CR>", { desc = "Move to right" })
map("n", "<leader><tab>o", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader><tab>F", "<cmd>tabm 0<CR>", { desc = "Move to first" })
map("n", "<leader><tab>L", "<cmd>tabm<CR>", { desc = "Move to last" })
map("n", "<leader><tab>t", "<cmd>tabs", { desc = "List all tabs" })

-- close unused buffers
local id = vim.api.nvim_create_augroup("startup", {
	clear = false,
})

local persistbuffer = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				persistbuffer()
			end,
		})
	end,
})

map("n", "<leader>b<space>", function()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
			vim.cmd("bd " .. tostring(bufnr))
		end
	end
end, { silent = true, desc = "Close unused buffers" })

-- Replace in selection
map("x", "ss", ":s/\\%V", { desc = "replace in selection" })

-- smart deletion, dd
-- It solves the issue, where you want to delete empty line, but dd will override you last yank.
-- Code above will check if u are deleting empty line, if so - use black hole register.
-- [src: https://www.reddit.com/r/neovim/comments/w0jzzv/comment/igfjx5y/?utm_source=share&utm_medium=web2x&context=3]
local function smart_dd()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	else
		return "dd"
	end
end
vim.keymap.set("n", "dd", smart_dd, { noremap = true, expr = true })

if vim.fn.executable("btop") == 1 and not Util.has("toggleterm.nvim") then
	-- btop
	map("n", "<leader>xb", function()
		Util.float_term({ "btop" })
	end, { desc = "btop" })
end