local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "

-- ============================================================
-- General
-- ============================================================

-- Save: Ctrl+S
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>wa<cr>", { desc = "Save file" })

-- Undo/Redo
map("n", "<C-z>", "u",        { desc = "Undo" })
map("n", "<C-y>", "<C-r>",    { desc = "Redo" })

-- Select all: Ctrl+A
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Quit buffer: Ctrl+W
map("n", "<C-w>", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Quit nvim
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit" })

-- ============================================================
-- Editing
-- ============================================================

-- Move lines up/down: Alt+Up / Alt+Down (works in normal, insert, visual)
map("n", "<A-Up>",   "<cmd>m .-2<cr>==",        { desc = "Move line up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==",         { desc = "Move line down" })
map("i", "<A-Up>",   "<Esc><cmd>m .-2<cr>==gi",  { desc = "Move line up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi",  { desc = "Move line down" })
map("v", "<A-Up>",   ":m '<-2<cr>gv=gv",         { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv",         { desc = "Move selection down" })

-- Delete line: Ctrl+Shift+K
map("n", "<C-S-k>", "<cmd>d<cr>",   { desc = "Delete line" })

-- Duplicate line: Ctrl+D (in normal mode; in visual mode Ctrl+D is scroll so we use Alt+D)
map("n", "<A-d>", "<cmd>t.<cr>",    { desc = "Duplicate line" })

-- Insert line below without entering insert: Ctrl+Enter
map("n", "<C-CR>",   "<cmd>put =''<cr>",  { desc = "Insert line below" })
-- Insert line above
map("n", "<C-S-CR>", "<cmd>put! =''<cr>", { desc = "Insert line above" })

-- Indent/outdent and stay in visual mode
map("v", "<Tab>",   ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent" })

-- Toggle comment: Ctrl+/ (nvim 0.10+ has built-in commenting)
map({ "n", "v" }, "<C-/>", "gcc", { desc = "Toggle comment", remap = true })

-- ============================================================
-- Navigation
-- ============================================================

-- Better window navigation: Ctrl+hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })

-- Buffer navigation: Ctrl+Tab / Ctrl+Shift+Tab
map("n", "<C-Tab>",   "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

-- Go to beginning/end of line in insert mode
map("i", "<C-b>", "<Home>", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>",  { desc = "Go to end of line" })

-- ============================================================
-- Search
-- ============================================================

-- Find in file: Ctrl+F
map("n", "<C-f>", "/", { desc = "Find in file" })

-- Clear search highlight: Esc in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ============================================================
-- LSP (supplement the ones set on LspAttach in lsp.lua)
-- ============================================================

-- Format: Shift+Alt+F (like VSCode)
map({ "n", "v" }, "<S-A-f>", function()
    require("conform").format({ lsp_fallback = true, timeout_ms = 500 })
end, { desc = "Format file" })
