-- Windsurf.nvim 配置
-- 注意：windsurf.nvim 实际上使用 codeium 模块，而不是 windsurf 模块
-- 尝试加载 codeium 模块
local status_ok, codeium = pcall(require, "codeium")
if not status_ok then
  vim.notify("codeium 模块未找到，windsurf.nvim 实际上是基于 codeium 的接口")
  return
end

-- 确保 nvim-cmp 已加载
local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  vim.notify("nvim-cmp 模块未找到，windsurf/codeium 需要 nvim-cmp 来实现补全功能")
  return
end

-- 使用 codeium 接口进行设置
codeium.setup({
  -- 基本配置
  enable_cmp_source = true,    -- 启用 cmp 集成
  enable_chat = true,          -- 启用聊天功能
  tools = {
    -- 补全相关设置
    completion = {
      -- 虚拟文本预览
      virtual_text = true,
    },
  },
  filetypes = {
    -- 默认启用所有文件类型
    ["*"] = true,
    -- 在这些文件类型中禁用
    ["help"] = false,
  },
})

-- 设置 nvim-cmp 集成
cmp.setup({
  -- 注册 codeium 作为 cmp 的源
  sources = cmp.config.sources({
    { name = "codeium" },     -- windsurf 实际使用 codeium 作为源
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- 创建 Windsurf 命令作为 Codeium 命令的别名
vim.api.nvim_create_user_command('Windsurf', function(opts)
  -- 直接转发到 Codeium 命令
  vim.cmd('Codeium ' .. opts.args)
end, {
  nargs = 1,
  complete = function()
    return { 'Auth', 'Toggle', 'Chat' }
  end
})

-- 设置按键映射
vim.keymap.set('n', '<leader>wt', ':Codeium Toggle<CR>', { noremap = true, silent = true }) -- 开关 Codeium
vim.keymap.set('n', '<leader>wc', ':Codeium Chat<CR>', { noremap = true, silent = true })   -- 打开聊天
vim.keymap.set('n', '<leader>wa', ':Codeium Auth<CR>', { noremap = true, silent = true })   -- 授权

-- 为键盘映射添加安全处理
local function safe_call(fn_name, arg)
  local ok, result = pcall(function()
    -- 尝试调用 codeium 对应的函数
    local mod_fn = ('codeium#%s'):format(fn_name)
    if vim.fn.exists('*' .. mod_fn) == 1 then
      if arg ~= nil then
        return vim.fn[mod_fn](arg)
      else
        return vim.fn[mod_fn]()
      end
    end
    return ''
  end)
  if not ok then return '' end
  return result
end

-- 设置补全接受与导航按键（使用 codeium 函数）
vim.keymap.set('i', '<C-y>', function() 
  return safe_call('Accept')
end, { expr = true, silent = true })

vim.keymap.set('i', '<C-n>', function() 
  return safe_call('NextCompletion', 1) -- 传递参数1，表示向下移动一个
end, { expr = true })

vim.keymap.set('i', '<C-p>', function() 
  return safe_call('PrevCompletion', 1) -- 传递参数1，表示向上移动一个
end, { expr = true })

vim.keymap.set('i', '<C-x>', function() 
  return safe_call('Clear')
end, { expr = true })