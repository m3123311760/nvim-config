-- 基本设置
local opt = vim.opt
local g = vim.g

-- 保留原始设置
g.python3_host_prog = '/home/stitch/.venvs/nvim/bin/python'

-- 主题设置
vim.cmd('colorscheme tokyonight')

-- 行号
opt.number = true -- 显示行号
opt.relativenumber = true -- 显示相对行号

-- tab 和缩进
opt.tabstop = 2 -- tab 为两个空格
opt.shiftwidth = 2 -- 缩进为两个空格
opt.expandtab = true -- 使用空格代替 tab
opt.autoindent = true -- 自动缩进
opt.smartindent = true -- 增加智能缩进

-- 搜索
opt.ignorecase = true -- 搜索时忽略大小写
opt.smartcase = true -- 搜索时忽略大小写
opt.hlsearch = true -- 高亮搜索

-- 外观
opt.termguicolors = true -- 使用 24 位颜色
opt.signcolumn = "yes" -- 显示符号列
opt.cursorline = true -- 高亮当前行
-- opt.colorcolumn = "80" -- 显示80列指示线
opt.mouse = "a" -- 启用鼠标

-- 性能
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 500 -- 映射等待时间
opt.encoding = "utf-8" -- 编码

-- 文件处理和备份
-- 注意：保留原始设置的 swap 和 backup 配置
opt.updatecount = 100 -- 保存文件时自动检查文件是否被修改
opt.swapfile = true -- 生成 swap 文件
opt.backup = true -- 生成备份文件
opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup//") -- 备份文件目录
opt.directory = vim.fn.expand("~/.local/share/nvim/swap//") -- swap 文件目录

-- 文本显示
opt.wrap = false -- 不自动换行
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.conceallevel = 0 -- 显示所有隐藏字符

-- 分割窗口方向
opt.splitright = true -- 垂直分割窗口在右侧
opt.splitbelow = true -- 水平分割窗口在下方

-- 代码折叠
opt.foldenable = true -- 启用折叠
opt.foldmethod = "indent" -- 基于缩进折叠
opt.foldlevel = 99 -- 默认展开所有代码

-- 匹配括号设置
opt.showmatch = true -- 显示匹配的括号
opt.matchtime = 2 -- 匹配括号的显示时间

-- 补全菜单设置
opt.pumheight = 10 -- 补全菜单高度
opt.pumblend = 10 -- 补全菜单透明度
opt.completeopt = { "menuone", "noselect", "noinsert" } -- 补全设置

-- 剪贴板设置
-- 使用系统剪贴板
opt.clipboard = "unnamedplus"

-- 尝试启用 OSC52 剪贴板支持（适用于远程 SSH 会话）
if vim.fn.has('nvim') == 1 then
  g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

-- 启用自动匹配括号和引号
g.loaded_matchparen = 1

