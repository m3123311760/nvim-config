-- 剪贴板配置
local has_osc, osc52 = pcall(require, 'osc52')
if not has_osc then
  vim.notify('osc52 插件未找到，剪贴板功能可能受限', vim.log.levels.WARN)
  return
end

-- OSC52 配置
osc52.setup {
  max_length = 0,           -- 最大长度（0表示无限制）
  silent = true,            -- 禁用通知
  trim = false,             -- 不裁剪空格
}

-- 设置复制方法
vim.keymap.set('n', '<leader>c', osc52.copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', osc52.copy_visual)

-- 覆盖默认的剪贴板寄存器
local function copy(lines, _)
  osc52.copy(table.concat(lines, '\n'))
  return 0
end

if vim.fn.has('clipboard') == 0 then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = nil, -- 无法从远程粘贴
      ['*'] = nil, -- 无法从远程粘贴
    },
  }
end