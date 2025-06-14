-- 注释插件配置
local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  vim.notify("Comment.nvim 插件未安装")
  return
end

comment.setup({
  pre_hook = function(ctx)
    local U = require("Comment.utils")
    local location = nil

    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require("ts_context_commentstring.utils").get_visual_start_location()
    end

    local status_ts_ok, ts_comment = pcall(require, "ts_context_commentstring.internal")
    if status_ts_ok then
      return ts_comment.calculate_commentstring({
        key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end
  end,

  mappings = {
    basic = true,
    extra = true,
    extended = true,
  }
})  -- ← ← ← ✅ 注意这里闭合了 comment.setup({ ... })

-- 快捷键绑定
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { desc = "注释当前行" })
vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "注释选中区域" })

