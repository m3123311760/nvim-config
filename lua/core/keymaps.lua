vim.g.mapleader = ' '

local opts = { noremap = true, silent = true }

vim.keymap.set('i', 'jk', '<Esc>', opts) -- j + k: 退出插入模式
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>') -- Space + n: 打开/关闭文件树
vim.keymap.set('v', '<A-u>', ":m <-2<CR>gv=gv") -- Space + u: 可视模式下上移两行
vim.keymap.set('v', '<A-j>', ":m >+1<CR>gv=gv") -- SPace + j: 可视模式下下移一行 
vim.keymap.set('n', '<A-u>', ":m .-2<CR>==") -- Space + u: 插入模式下上移两行
vim.keymap.set('n', '<A-j>', ":m .+1<CR>==") -- Space + j: 插入模式下下移一行
vim.keymap.set('n', '<leader>sv','<C-w>v') -- Space + s + v: 正常模式下水平分割窗口
vim.keymap.set('n', '<leader>sh','<C-w>s') -- Space + s + h: 正常模式下垂直分割窗口
vim.keymap.set('n', '<leader>s', ':w<CR>') -- Space + s: 正常模式下保存文件
vim.keymap.set('i', '<leader>s', '<Esc>:wa<CR>') -- Space + s: 插入模式下保存所有打开文件
vim.keymap.set('n', '<leader>nh', ':noh<CR>') -- Space + n + h: 正常模式下取消搜索高亮
vim.keymap.set ('i', "<C-Space>", "coc#refresh()", { silent = true, expr = true }) -- Ctrl + Space: 刷新补全项
vim.keymap.set('i', '<leader><CR>', 'copilot#AcceptLine()', { silent = true, expr = true, noremap = true }) -- Space + Enter: 插入模式下接受copilot建议
vim.keymap.set('i', "<Esc>", [[ coc#pum#visible() ? coc#pum#cancel() : "<Esc>"]], { silent = true, expr = true, noremap = true }) -- Esc: 关闭补全项]])
vim.keymap.set('i', "<S-Tab>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], { silent = true, noremap = true, expr = true, replace_keycodes = false }) -- Shift + Tab: 选择上一个补全项
vim.keymap.set('i', "<Tab>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<Tab>" : coc#refresh()', { silent = true, noremap = true, expr = true }) -- Tab: 选择下一个补全项
vim.keymap.set('i', "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { silent = true, noremap = true, expr = true }) -- Enter: 确认补全项
vim.keymap.set('i', "<C-j>", "<Plug>(coc-snippets-expand-jump)") -- Ctrl + j: 展开代码片段
vim.keymap.set('n', "<leader>+", "<Plug>(coc-diagnostic-prev)") -- Space + +: 跳转到上一个诊断
vim.keymap.set('n', "<leader>-", "<Plug>(coc-diagnostic-next)") -- Space + -: 跳转到下一个诊断
vim.keymap.set('n', "gd", "<Plug>(coc-definition)") -- gd: 跳转到定义)
vim.keymap.set('n', "gy", "<Plug>(coc-type-definition)") -- gy: 跳转到类型定义)
vim.keymap.set('n', "gi", "<Plug>(coc-implementation)") -- gi: 跳转到实现)
vim.keymap.set('n', "gr", "<Plug>(coc-references)") -- gr: 跳转到引用)
vim.keymap.set('n', "K", "<CMD>lua _G.show_docs()<CR>") -- K: 显示文档
vim.keymap.set('n', "<leader>rn", "<Plug>(coc-rename)") -- Space + rn: 重命名")
vim.keymap.set('n', "<leader>f", "<Plug>(coc-format)") -- Space + f: 格式化
vim.keymap.set('x', "<leader>f", "<Plug>(coc-format-selected)") -- Space + f: 选中区域格式化))
vim.keymap.set('n', "<leader>n", ":BufferLineCycleNext<CR>") -- Space + n: 切换到下一个buffer
vim.keymap.set('n', "<leader>p", ":BufferLineCyclePrev<CR>") -- Space + p: 切换到上一个buffer
vim.keymap.set('n', "<Tab>h", ":BufferLineCyclePrev<CR>") -- Tab + h: 切换到上一个buffer
vim.keymap.set('n', "<Tab>k", ":BufferLineCycleNext<CR>") -- Tab + l: 切换到下一个buffer
vim.keymap.set('n', "<leader>q", ":bdelete<CR>") -- Space + q: 关闭左侧buffer
