-- 代码片段配置
local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
  vim.notify("luasnip 插件未安装")
  return
end

-- 加载 friendly-snippets 库
require("luasnip.loaders.from_vscode").lazy_load()

-- 设置快速跳转的键位映射
vim.keymap.set({"i", "s"}, "<C-j>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({"i", "s"}, "<C-k>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- 设置代码片段跳转
vim.keymap.set("i", "<C-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)

-- 动态处理片段
luasnip.config.set_config({
  history = true, -- 记住代码片段状态
  updateevents = "TextChanged,TextChangedI", -- 在文本变化时更新
  enable_autosnippets = true, -- 启用自动代码片段
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = {{"选择", "Error"}}
      }
    }
  }
})

-- 全局变量
luasnip.variables = {
  username = "user",
  real_name = "User",
  email = "user@example.com",
}

-- 定义自定义代码片段
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local c = luasnip.choice_node
local d = luasnip.dynamic_node
local r = luasnip.restore_node

-- 对于各种语言添加自定义代码片段
luasnip.add_snippets("all", {
  -- 当前日期
  s("date", {
    f(function() return os.date("%Y-%m-%d") end, {})
  }),
  -- 当前时间
  s("time", {
    f(function() return os.date("%H:%M:%S") end, {})
  }),
  -- 用户信息
  s("user", {
    f(function() return vim.g.username or "user" end, {})
  })
})
