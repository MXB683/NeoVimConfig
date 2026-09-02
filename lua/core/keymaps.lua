local map = vim.keymap.set

vim.g.mapleader = " "

-- ============================================================
-- General
-- ============================================================

map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>wa<cr>", { desc = "Save file" })

map("n", "<C-z>", "u",        { desc = "Undo" })
map("n", "<C-y>", "<C-r>",    { desc = "Redo" })

map("n", "<C-a>", "ggVG", { desc = "Select all" })

map("n", "<C-w>", "<cmd>bdelete<cr>", { desc = "Close buffer" })

map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit" })

-- ============================================================
-- Editing
-- ============================================================

map("n", "<A-Up>",   "<cmd>m .-2<cr>==",        { desc = "Move line up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==",         { desc = "Move line down" })
map("i", "<A-Up>",   "<Esc><cmd>m .-2<cr>==gi",  { desc = "Move line up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<cr>==gi",  { desc = "Move line down" })
map("v", "<A-Up>",   ":m '<-2<cr>gv=gv",         { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv",         { desc = "Move selection down" })

map("n", "<C-S-k>", "<cmd>d<cr>",   { desc = "Delete line" })

map("n", "<A-d>", "<cmd>t.<cr>",    { desc = "Duplicate line" })

map("n", "<C-CR>",   "<cmd>put =''<cr>",  { desc = "Insert line below" })
map("n", "<C-S-CR>", "<cmd>put! =''<cr>", { desc = "Insert line above" })

map("v", "<Tab>",   ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent" })

map({ "n", "v" }, "<C-/>", "gcc", { desc = "Toggle comment", remap = true })

map("n", "<leader>cp", "<cmd>CccPick<cr>", { desc = "Pick color" })

-- ============================================================
-- Navigation
-- ============================================================

map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })

map("n", "<C-Tab>",   "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

map("i", "<C-b>", "<Home>", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>",  { desc = "Go to end of line" })

-- ============================================================
-- Search
-- ============================================================

map("n", "<C-f>", "/", { desc = "Find in file" })

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ============================================================
-- LSP (supplement the ones set on LspAttach in lsp.lua)
-- ============================================================

map({ "n", "v" }, "<S-A-f>", function()
    require("conform").format({ lsp_fallback = true, timeout_ms = 500 })
end, { desc = "Format file" })
