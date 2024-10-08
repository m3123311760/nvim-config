vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.tabstop = 2 -- tab 为两个空格
vim.opt.shiftwidth = 2 -- 缩进为两个空格
vim.opt.expandtab = true -- 使用空格代替 tab
vim.opt.autoindent = true -- 自动缩进
vim.opt.wrap = false -- 不自动换行
vim.opt.cursorline = true -- 高亮当前行
vim.opt.mouse:append("a") -- 启用鼠标
vim.opt.clipboard:append("unnamedplus") -- 系统剪贴板
vim.opt.signcolumn = "yes" -- 显示符号列
vim.opt.encoding = "utf-8" -- 编码
vim.opt.updatecount = 100 -- 保存文件时自动检查文件是否被修改
vim.opt.swapfile = true -- 生成 swap 文件
vim.opt.backup = true -- 生成备份文件
vim.opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup//") -- 备份文件目录
vim.opt.directory = vim.fn.expand("~/.local/share/nvim/swap//") -- swap 文件目录
vim.opt.termguicolors = true -- 使用 24 位颜色
vim.opt.splitright = true -- 垂直分割窗口在右侧
vim.opt.splitbelow = true -- 水平分割窗口在下方
vim.opt.ignorecase = true -- 搜索时忽略大小写
vim.opt.smartcase = true -- 搜索时忽略大小写
vim.cmd[[colorscheme tokyonight]]
