local Util = require("saturn.utils.plugin")

local map = vim.keymap.set

-- colemak movement
map("", "e", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("", "u", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("", "n", "h")
map("", "i", "l")

-- colemak jump to start/end of the line
map("", "N", "^")
map("", "I", "$")
-- colemak fast navigation
map("", "U", "5k")
map("", "E", "5j")

-- colemak insert key
map("", "k", "i")
map("", "K", "I")
map("", "gk", "gi", { desc = "goto last insert" })

-- colemake undo key
map("", "l", "u")
map("", "L", "U")

-- colemak end of word
map("", "h", "e")
map("", "H", "K")

-- colemake searching key
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("", "=", "'Nn'[v:searchforward]", { expr = true })
map("", "-", "'nN'[v:searchforward]", { expr = true })

-- search work under cursor
map("n", "gw", "*N")
map("x", "gw", "*N")

-- clear search with <esc>
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better cmd mode
map("n", ":", ",")
map("n", "<cr>", ":")
-- backup cmd mode, some plugins will override <cr>
map("n", "\\", ":")

-- save
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>wa<cr><esc>")
map("", "S", "<cmd>w<cr><esc>")

-- quit
map("", "Q", "<cmd>q<cr>")
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- select all
map("", "<C-a>", "<esc>ggVG")

-- new space line
map("n", "<C-cr>", "o<esc>")

-- paste
map("i", "<C-v>", "<C-g>u<Cmd>set paste<CR><C-r>+<Cmd>set nopaste<CR>")
map("t", "<C-v>", "<C-\\><C-N>pi")
map("c", "<C-v>", "<C-r>+")

-- inc/dec number
map("", "<C-=>", "<C-a>")
map("", "<C-->", "<C-x>")

-- Column inc/dec numbers
map("v", "g<C-=>", "g<C-a>")
map("v", "g<C-->", "g<C-x>")

-- better indentation
map("n", "<", "<<")
map("n", ">", ">>")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Better Copy
map("n", "Y", "y$")
map("v", "Y", '"+y')

-- Move lines
map("n", "<A-e>", ":m .+1<CR>==")
map("v", "<A-e>", ":m '>+1<CR>gv=gv")
map("i", "<A-e>", "<Esc>:m .+1<CR>==gi")
map("n", "<A-u>", ":m .-2<CR>==")
map("v", "<A-u>", ":m '<-2<CR>gv=gv")
map("i", "<A-u>", "<Esc>:m .-2<CR>==gi")

-- Switch buffer with tab
map("n", "<tab>", "<cmd>bnext<cr>")
map("n", "<s-tab>", "<cmd>bprevious<cr>")

-- insert mode navigation
map("i", "<A-Up>", "<C-\\><C-N><C-w>k")
map("i", "<A-Down>", "<C-\\><C-N><C-w>j")
map("i", "<A-Left>", "<C-\\><C-N><C-w>h")
map("i", "<A-Right>", "<C-\\><C-N><C-w>l")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- lazy
map("n", "<leader>pi", "<cmd>Lazy install<cr>", { desc = "Install" })
map("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync" })
map("n", "<leader>pC", "<cmd>Lazy clear<cr>", { desc = "Status" })
map("n", "<leader>pc", "<cmd>Lazy clean<cr>", { desc = "Clean" })
map("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update" })
map("n", "<leader>pp", "<cmd>Lazy profile<cr>", { desc = "Profile" })
map("n", "<leader>pl", "<cmd>Lazy log<cr>", { desc = "Log" })
map("n", "<leader>pd", "<cmd>Lazy debug<cr>", { desc = "Debug" })

-- Terminal window navigation
map("t", "<C-n>", "<C-\\><C-N><C-w>h", { desc = "move to left" })
map("t", "<C-e>", "<C-\\><C-N><C-w>j", { desc = "move to down" })
map("t", "<C-u>", "<C-\\><C-N><C-w>k", { desc = "move to up" })
map("t", "<C-i>", "<C-\\><C-N><C-w>l", { desc = "move to right" })

map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- navigate tab completion with <c-e> and <c-j>
-- runs conditionally
map("c", "<C-e>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true })
map("c", "<C-u>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true })

-- goto new position in jumplist
map("n", "<C-h>", "<C-i>")

-- Windows managenment
--Better window movement
map("n", "<C-w>", "<C-w>w", { desc = "Switch window" })
map("n", "<C-x>", "<C-w>x")
map("n", "<C-n>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-e>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-u>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-i>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-l>", "<C-w>o", { desc = "Clear other windwos" })
map("n", "<C-q>", "<C-w>q", { desc = "Quit window" })

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- disable the default s key
map({ "n", "v" }, "s", "<nop>", { desc = "split/surround/select" })

-- split the screens
map("n", "su", ":set nosplitbelow<CR>:split<CR>:set splitbelow<CR>", { desc = "split above" })
map("n", "se", ":set splitbelow<CR>:split<CR>", { desc = "split below" })
map("n", "sn", ":set nosplitright<CR>:vsplit<CR>:set splitright<CR>", { desc = "split left" })
map("n", "si", ":set splitright<CR>:vsplit<CR>", { desc = "split right" })

-- Rotate window
map("n", "<leader>wU", "<C-w>b<C-w>K", { desc = "rotate window up" })
map("n", "<leader>wN", "<C-w>b<C-w>H", { desc = "rotate window left" })

map("n", "<leader>ww", "<C-W>p", { desc = "other-window" })
map("n", "<leader>wd", "<C-W>c", { desc = "delete-window" })
-- move current windwo to the far left, bottom, right, top
map("n", "<leader>wn", "<C-w>H", { desc = "move to the far left" })
map("n", "<leader>we", "<C-w>J", { desc = "move to the far bottom" })
map("n", "<leader>wi", "<C-w>L", { desc = "move to the far right" })
map("n", "<leader>wu", "<C-w>K", { desc = "move to the far top" })

-- scroll
map({ "n", "v" }, "<C-k>", "<C-u>")
map({ "n", "v" }, "<C-m>", "<C-e>")

-- Tabs management
map("n", "<leader><tab>a", "<cmd>tabfirst<CR>", { desc = "First" })
map("n", "<leader><tab>z", "<cmd>tablast<CR>", { desc = "Last" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "]<tab>", "<cmd>tabn<CR>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabp<CR>", { desc = "Prev Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close" })
map("n", "<leader><tab>s", "<cmd>tab split<CR>", { desc = "Split" })
map("n", "<leader><tab>N", "<cmd>-tabmove<CR>", { desc = "Move to left" })
map("n", "<leader><tab>I", "<cmd>+tabmove<CR>", { desc = "Move to right" })
map("n", "<leader><tab>l", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<leader><tab>A", "<cmd>tabm 0<CR>", { desc = "Move to first" })
map("n", "<leader><tab>Z", "<cmd>tabm<CR>", { desc = "Move to last" })
map("n", "<leader><tab>t", "<cmd>tabs", { desc = "List all tabs" })

-- buffers
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bpreviout<CR>", { desc = "Previous Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- files
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- quickfix
map("n", "<leader>tl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>tq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Replace in selection
map("x", "s<cr>", ":s/\\%V", { desc = "replace in selection" })

-- toggle optional
map("n", "<leader>uf", require("saturn.plugins.lsp.format").toggle, { desc = "Toggle format on save" })
map("n", "<leader>us", function()
  Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function()
  Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function()
  Util.toggle("relativenumber", true)
  Util.toggle("number")
end, { desc = "Toggle Line Numbers" })

map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
  Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end
