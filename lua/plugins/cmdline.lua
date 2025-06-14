-- 命令行补全配置

local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
  vim.notify("nvim-cmp 未安装，命令行补全不可用")
  return
end

-- 获取系统 shell 类型
local default_shell = vim.o.shell
local is_zsh = default_shell:find("zsh") ~= nil
local is_bash = default_shell:find("bash") ~= nil

-- 配置 ! 命令补全
cmp.setup.cmdline("!", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },          -- 文件路径补全
    { name = "cmdline" },       -- 命令补全
    { name = "cmdline_history" }, -- 命令历史补全
  }),
  -- 自定义补全格式
  formatting = {
    format = function(entry, vim_item)
      -- 设置不同来源的菜单标签
      vim_item.menu = ({
        buffer = "[缓冲区]",
        path = "[路径]",
        cmdline = "[命令]",
        cmdline_history = "[历史]",
      })[entry.source.name]
      
      return vim_item
    end,
  },
  view = {
    entries = { name = "wildmenu", separator = " | " },
  }
})

-- 配置 : 命令补全
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
    { name = "cmdline" },
    { name = "cmdline_history" },
  }),
  view = {
    entries = { name = "custom", selection_order = "near_cursor" },
  }
})

-- 配置 / 搜索补全
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
    { name = "cmdline_history" },
  },
  view = {
    entries = { name = "custom", selection_order = "near_cursor" },
  }
})

-- 自动启用命令行模式的补全
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = {":", "/", "?", "!"},
  callback = function()
    vim.o.wildcharm = 9  -- <Tab> 字符
    vim.keymap.set("c", "<Tab>", function()
      if cmp.visible() then
        cmp.select_next_item()
      else
        vim.api.nvim_feedkeys(string.char(vim.o.wildcharm), "nt", false)
      end
    end, { expr = false, silent = true })

    vim.keymap.set("c", "<S-Tab>", function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        vim.api.nvim_feedkeys(string.char(vim.o.wildcharm), "nt", false)
      end
    end, { expr = false, silent = true })
  end
})

-- 为 bash/zsh 添加自定义的命令补全
if is_zsh or is_bash then
  vim.api.nvim_create_user_command("ShellCompletions", function()
    -- 获取当前命令行内容
    local cmdline = vim.fn.getcmdline()
    local cmd_start = cmdline:match("^%s*!%s*(.+)$")
    
    if cmd_start then
      -- 执行 compgen 获取可能的补全选项
      local shell_type = is_zsh and "zsh" or "bash"
      local options = vim.fn.system(shell_type .. " -c 'compgen -c " .. cmd_start .. "'")
      
      -- 显示结果
      if options and options ~= "" then
        print("补全选项: " .. options:gsub("\n", " "))
      end
    end
  end, {})
  
  -- 添加键位映射
  vim.api.nvim_set_keymap("c", "<C-x><C-z>", "<cmd>ShellCompletions<CR>", { noremap = true, silent = true })
end