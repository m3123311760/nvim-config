-- 命令配置

-- 使用 Neovim 原生 API 创建自动命令
vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
  pattern = "*",
  command = "silent! wall", -- 自动保存
  desc = "自动保存修改过的缓冲区"
})

-- 为 LSP 设置文档高亮（替代 coc highlight 功能）
vim.api.nvim_create_autocmd({"CursorHold"}, {
  pattern = "*",
  callback = function()
    if vim.lsp.buf.server_ready() then
      vim.lsp.buf.document_highlight()
    end
  end,
  desc = "LSP 文档高亮"
})

vim.api.nvim_create_autocmd({"CursorMoved"}, {
  pattern = "*",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
  desc = "清除 LSP 文档高亮"
})

-- 保存时自动格式化
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.lua", "*.py", "*.js", "*.jsx", "*.ts", "*.tsx"},
  callback = function()
    local save_cursor = vim.fn.getcurpos()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- 打开文件时恢复光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})
