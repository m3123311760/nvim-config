-- 常用函数

-- 自动安装目录创建
local function ensure_directories()
  local data_dir = vim.fn.stdpath('data')
  local config_dir = vim.fn.stdpath('config')
  
  -- 确保数据目录存在
  if vim.fn.isdirectory(data_dir) == 0 then
    vim.fn.mkdir(data_dir, 'p')
  end
  
  -- 确保配置目录存在
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.fn.mkdir(config_dir, 'p')
  end
end

-- 检查光标前是否为空白字符（用于补全）
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

-- 显示文档信息（替代 CocActionAsync('doHover')）
function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
    -- vim 和 help 文件使用内置的帮助系统
    vim.api.nvim_command('h ' .. cw)
  elseif vim.lsp.buf.server_ready() then
    -- 使用 LSP 显示悬浮文档
    vim.lsp.buf.hover()
  else
    -- 回退到系统默认的关键字查询程序
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

-- 辅助函数：检查 LSP 服务器是否已准备就绪
function vim.lsp.buf.server_ready()
  local buf_clients = vim.lsp.buf_get_clients()
  if next(buf_clients) == nil then
    return false
  end
  return true
end

-- 剪贴板辅助函数
-- 使用 OSC52 功能复制到系统剪贴板
function _G.osc52_copy(text)
  local base64 = require('vim.base64')
  local encoded = base64.encode(text)
  local csi = string.char(0x1b)..'['
  local osc = string.char(0x1b)..']'
  
  -- 使用 OSC52 转义序列写入到标准输出
  io.write(osc..'52;c;'..encoded..string.char(0x07))
end

-- 全选并复制到系统剪贴板
function _G.select_all_and_copy()
  vim.cmd('normal! ggVG')
  vim.cmd('normal! "+y')
end

-- 剪贴板未提供时，使用备用功能
function _G.setup_fallback_clipboard()
  -- 如果没有剪贴板提供程序，则设置快捷键
  vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc = "复制到系统剪贴板"})
  vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', {desc = "从系统剪贴板粘贴"})
  vim.keymap.set('n', '<leader>P', '"+P', {desc = "从系统剪贴板粘贴（前插）"})
  vim.keymap.set('n', '<leader>Y', '"+Y', {desc = "复制当前行到系统剪贴板"})
  vim.keymap.set('n', '<leader>aa', _G.select_all_and_copy, {desc = "全选并复制"})
end

-- 运行确保目录存在
ensure_directories()

-- 初始化剪贴板
_G.setup_fallback_clipboard()

