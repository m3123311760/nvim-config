vim.g.mapleader = ' '

local opts = { noremap = true, silent = true }

-- 基础编辑与导航
vim.keymap.set('i', 'jk', '<Esc>', opts) -- 快速退出插入模式
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts) -- 取消搜索高亮
vim.keymap.set('n', '<leader>w', ':w<CR>', opts) -- 保存文件
vim.keymap.set('n', '<leader>wq', ':wq<CR>', opts) -- 保存并退出
vim.keymap.set('n', '<leader>q', ':q<CR>', opts) -- 退出
vim.keymap.set('n', '<leader>Q', ':qa!<CR>', opts) -- 强制退出所有

-- 窗口管理
vim.keymap.set('n', '<leader>sv', '<C-w>v', opts) -- 垂直分割窗口
vim.keymap.set('n', '<leader>sh', '<C-w>s', opts) -- 水平分割窗口
vim.keymap.set('n', '<C-h>', '<C-w>h', opts) -- 移动到左侧窗口
vim.keymap.set('n', '<C-j>', '<C-w>j', opts) -- 移动到下方窗口
vim.keymap.set('n', '<C-k>', '<C-w>k', opts) -- 移动到上方窗口
vim.keymap.set('n', '<C-l>', '<C-w>l', opts) -- 移动到右侧窗口
vim.keymap.set('n', '<leader>+', ':vertical resize +5<CR>', opts) -- 增加窗口宽度
vim.keymap.set('n', '<leader>-', ':vertical resize -5<CR>', opts) -- 减少窗口宽度

-- 行移动
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", opts) -- 可视模式下移行
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", opts) -- 可视模式上移行
vim.keymap.set('n', '<A-j>', ":m .+1<CR>==", opts) -- 正常模式下移行
vim.keymap.set('n', '<A-k>', ":m .-2<CR>==", opts) -- 正常模式上移行

-- 缓冲区管理
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', opts) -- 下一个缓冲区
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', opts) -- 上一个缓冲区
vim.keymap.set('n', '<leader>x', ':bdelete<CR>', opts) -- 关闭当前缓冲区
vim.keymap.set('n', '<leader>X', ':bufdo bdelete<CR>', opts) -- 关闭所有缓冲区

-- 文件导航
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', opts) -- 文件树
vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', opts) -- 聚焦到文件树

-- 代码补全和AI辅助
-- AI 辅助按键映射在 plugins/windsurf.lua 文件中配置

-- 使用 nvim-cmp 的补全导航
-- Tab和S-Tab映射将在 cmp.setup() 中配置，位于 lsp.lua 文件中

-- 代码导航（使用内置LSP而非coc）
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "上一个诊断" }) -- 上一个诊断
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "下一个诊断" }) -- 下一个诊断
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "跳转到定义" }) -- 跳转到定义
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "跳转到声明" }) -- 跳转到声明
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = "跳转到类型定义" }) -- 跳转到类型定义
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "跳转到实现" }) -- 跳转到实现
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "查找引用" }) -- 查找引用
vim.keymap.set('n', 'K', '<CMD>lua _G.show_docs()<CR>', { desc = "显示文档" }) -- 显示文档

-- 代码操作（使用内置LSP而非coc）
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "重命名" }) -- 重命名
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, { desc = "格式化" }) -- 格式化
vim.keymap.set('x', '<leader>f', vim.lsp.buf.format, { desc = "选中区域格式化" }) -- 选中区域格式化
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "代码操作" }) -- 代码操作
vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, { desc = "修复当前问题" }) -- 自动修复（也使用代码操作）
