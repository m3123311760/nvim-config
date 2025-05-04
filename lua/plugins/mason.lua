-- Mason - LSP, DAP, Linter, Formatter 安装管理器配置

-- 检查是否安装了 Mason
local status_ok, mason = pcall(require, "mason")
if not status_ok then
  vim.notify("mason.nvim 插件未安装，无法使用语言服务器管理功能")
  return
end

-- 检查是否安装了 mason-lspconfig
local status_mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_mason_lspconfig_ok then
  vim.notify("mason-lspconfig.nvim 插件未安装")
  return
end

-- 配置 Mason
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
    keymaps = {
      toggle_package_expand = "<CR>",
      install_package = "i",
      update_package = "u",
      check_package_version = "c",
      update_all_packages = "U",
      check_outdated_packages = "C",
      uninstall_package = "X",
      cancel_installation = "<C-c>",
      apply_language_filter = "<C-f>",
    },
  },
  -- 自动安装语言服务器时使用的包管理器
  install_root_dir = vim.fn.stdpath("data") .. "/mason",
  pip = {
    upgrade_pip = true,
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
})

-- 推荐安装的语言服务器
local servers = {
  "lua_ls",        -- Lua
  "pyright",       -- Python
  "ts_ls",         -- TypeScript
  "clangd",        -- C/C++
  "html",          -- HTML
  "cssls",         -- CSS
  "jsonls",        -- JSON
  "yamlls",        -- YAML
  "gopls",         -- Go
  "bashls",        -- Bash
  "marksman",      -- Markdown
}

-- 配置自动安装
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- 提供命令，显示推荐安装的语言服务器
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(servers, " "))
end, {})

-- 添加多种键位映射，打开 Mason 界面
vim.keymap.set("n", "<leader>m", ":Mason<CR>", { noremap = true, silent = true, desc = "打开 Mason 界面" })
vim.keymap.set("n", "<leader>M", ":Mason<CR>", { noremap = true, silent = true, desc = "打开 Mason 界面" })
vim.keymap.set("n", "<leader>pm", ":Mason<CR>", { noremap = true, silent = true, desc = "打开 Mason 界面" })

-- 创建用户命令
vim.api.nvim_create_user_command("OpenMason", function()
  vim.cmd("Mason")
end, {})

-- 添加启动消息
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.api.nvim_echo({
        {"Mason 可通过 <leader>m, <leader>M, <leader>pm 或命令 :Mason 打开", "WarningMsg"}
      }, false, {})
    end, 1000)
  end,
  once = true,
})