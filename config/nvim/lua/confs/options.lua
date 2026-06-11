vim.g.mapleader = " "
vim.g.maplocalleader = ";"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.opt.wrap = false
vim.opt.whichwrap = ""
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "  > "

vim.opt.formatoptions = "c,r,j"

vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

vim.opt.fileformats = {'unix'}
vim.opt.fileencoding = "utf-8"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.pumheight = 15

vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 20
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = {
  tab = '»·',
  trail = '·',
  extends = '<',
  precedes = '>',
  conceal = '┊',
  nbsp = '␣',
}
