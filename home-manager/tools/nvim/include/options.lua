local option = vim.opt

option.textwidth = 80
option.autoindent = true
option.relativenumber = true
option.incsearch = true -- Get results as you type
option.shiftwidth = 4
option.tabstop
option.cursorline = true
option.number = true -- Show line number
option.linebreak = true -- Stops words being broken on wrap
option.expandtab = true -- Spaces instead of tabs
option.ignorecase = true -- Case insensitive search
option.foldmethod = "marker"

vim.o.ch = 0 -- Command height
vim.o.ls = 0 -- Last status

vim.cmd("colorscheme duskfox") -- Set theme
