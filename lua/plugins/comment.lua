-- 注释插件配置
local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  vim.notify("Comment.nvim 插件未安装")
  return
end

-- 基本设置
comment.setup({
  -- 预选模式中添加注释
  pre_hook = function(ctx)
    -- 只在本地缓冲区启用注释
    local U = require("Comment.utils")
    
    -- 确定要使用的键位映射
    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    -- 尝试使用 treesitter 上下文进行注释
    local status_ts_ok, ts_comment = pcall(require, "ts_context_commentstring.internal")
    if status_ts_ok then
      return ts_comment.calculate_commentstring({
        key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end
  end,
  
  -- 启用额外键映射
  mappings = {
    -- 注释当前行
    basic = true,
    -- 额外的注释映射
    extra = true,
    -- 注释当前行到行尾
    extended = true,
  },
  
  -- 设置不同语言的注释字符串
  languages = {
    python = {
      __default = '# %s',
      __multiline = '"""", """",
    },
    lua = {
      __default = '-- %s',
      __multiline = '--[[', '--]]',
    },
  },
})

-- 添加额外的键位映射
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "注释当前行" })
vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "注释选中区域" })