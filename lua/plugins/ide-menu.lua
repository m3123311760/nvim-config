-- IDE 菜单配置

-- 定义一个生成 IDE 相关菜单的函数
local function open_ide_menu()
  local items = {
    { text = "Mason 包管理器", action = "Mason" },
    { text = "LSP 信息", action = "LspInfo" },
    { text = "符号大纲", action = "SymbolsOutline" },
    { text = "调试器: 运行", action = "lua require'dap'.continue()" },
    { text = "调试器: 切换断点", action = "lua require'dap'.toggle_breakpoint()" },
    { text = "调试器: UI", action = "lua require'dapui'.toggle()" },
    { text = "运行任务", action = "OverseerRun" },
    { text = "任务面板", action = "OverseerToggle" },
    { text = "运行当前文件", action = "RunFile" },
    { text = "测试: 运行当前文件", action = "lua require'neotest'.run.run(vim.fn.expand('%'))" },
    { text = "测试: 摘要", action = "lua require'neotest'.summary.toggle()" },
  }

  -- 创建菜单
  vim.ui.select(items, {
    prompt = "选择 IDE 功能:",
    format_item = function(item)
      return item.text
    end,
  }, function(item)
    if item then
      vim.cmd(item.action)
    end
  end)
end

-- 创建命令
vim.api.nvim_create_user_command("IDEMenu", function()
  open_ide_menu()
end, {})

-- 添加键位映射
vim.keymap.set("n", "<leader>i", ":IDEMenu<CR>", { noremap = true, silent = true, desc = "打开 IDE 功能菜单" })
vim.keymap.set("n", "<leader>ii", ":IDEMenu<CR>", { noremap = true, silent = true, desc = "打开 IDE 功能菜单" })
vim.keymap.set("n", "<F1>", ":IDEMenu<CR>", { noremap = true, silent = true, desc = "打开 IDE 功能菜单" })

-- 添加额外的快捷键
vim.keymap.set("n", "<leader>mm", ":Mason<CR>", { noremap = true, silent = true, desc = "打开 Mason 界面" })
vim.keymap.set("n", "<leader>mi", ":MasonInstallAll<CR>", { noremap = true, silent = true, desc = "安装所有推荐工具" })
vim.keymap.set("n", "<leader>md", ":Mason<CR>", { noremap = true, silent = true, desc = "打开 Mason 界面" })

-- 发送通知
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_echo({
        {"IDE 功能可通过 <F1> 或 <leader>i 访问", "MoreMsg"}
      }, false, {})
    end, 2000)
  end,
  once = true,
})