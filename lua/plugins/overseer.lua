-- 编译运行配置 (Overseer)
local status_ok, overseer = pcall(require, "overseer")
if not status_ok then
  vim.notify("overseer.nvim 未安装")
  return
end

-- 基本设置
overseer.setup({
  -- 启用调试日志
  log_level = vim.log.levels.DEBUG,
  -- 任务模板设置
  templates = {
    "builtin",    -- 使用内置模板
  },
  -- 任务列表设置
  task_list = {
    direction = "right",  -- 在右侧打开任务列表
    min_width = 40,      -- 最小宽度
    max_width = 60,      -- 最大宽度
    default_detail = 1,  -- 默认详情级别
    bindings = {
      ["<CR>"] = "RunAction",
      ["<C-e>"] = "Edit",
      ["<C-a>"] = "OpenAll",
      ["<C-q>"] = "Close",
    },
  },
  form = {
    border = "rounded",       -- 设置表单边框
    win_opts = {              -- 窗口选项
      winblend = 10,          -- 背景透明度
    },
  },
  task_win = {
    border = "rounded",       -- 任务窗口边框
  },
  confirm = {
    border = "rounded",       -- 确认窗口边框
  },
  -- 组件设置
  component_aliases = {
    -- 默认别名
    default = {
      "on_output_summarize",
      "on_exit_set_status",
      "on_complete_notify",
      "on_complete_dispose"
    },
    -- 保持终端打开的别名
    default_nofail = {
      "on_output_summarize",
      "on_exit_set_status",
      { "on_complete_notify", failure_only = true },
    },
    -- 保持任务打开的别名
    always_keep = {
      "on_output_summarize",
      "on_exit_set_status",
      { "on_complete_notify", failure_only = true },
      "on_complete_keep",
    },
  },
  -- 自动清除完成的任务
  autostart_configs = {
    -- 不自动开始
  },
  -- 为长时间运行的任务设置默认处理方式
  strategy = {
    "jobstart",
    use_terminal = true,
    maintain_cwd = true,
  },
})

-- 检测文件类型并设置编译命令
local filetypes = {
  c = {
    name = "编译运行 C",
    cmd = { "gcc", "${file}", "-o", "${file_basename}", "&&", "./${file_basename}" },
    components = { "default" },
  },
  cpp = {
    name = "编译运行 C++",
    cmd = { "g++", "${file}", "-o", "${file_basename}", "&&", "./${file_basename}" },
    components = { "default" },
  },
  python = {
    name = "运行 Python",
    cmd = { "python3", "${file}" },
    components = { "default" },
  },
  go = {
    name = "运行 Go",
    cmd = { "go", "run", "${file}" },
    components = { "default_nofail" }, -- 使用不同的组件集
    strategy = {
      "terminal",
      open_on_start = true,
      direction = "float",
    },
  },
  rust = {
    name = "编译运行 Rust",
    cmd = { "cargo", "run", "--quiet" },
    cwd = "${workspaceFolder}",
    components = { "default" },
  },
  javascript = {
    name = "运行 JavaScript",
    cmd = { "node", "${file}" },
    components = { "default" },
  },
  typescript = {
    name = "运行 TypeScript",
    cmd = { "deno", "run", "${file}" },
    components = { "default" },
  },
  java = {
    name = "编译运行 Java",
    cmd = { "javac", "${file}", "&&", "java", "${file_basename}" },
    components = { "default" },
  },
  lua = {
    name = "运行 Lua",
    cmd = { "lua", "${file}" },
    components = { "default" },
  },
  sh = {
    name = "运行 Shell 脚本",
    cmd = { "bash", "${file}" },
    components = { "default" },
  },
}

-- 将文件类型关联到模板
for ft, config in pairs(filetypes) do
  overseer.register_template({
    name = config.name,
    builder = function()
      local file = vim.fn.expand("%:p")               -- 当前文件路径
      local file_basename = vim.fn.expand("%:t:r")     -- 不带扩展名的文件名
      local cmd_string = table.concat(config.cmd, " ")
      
      -- 替换占位符
      cmd_string = cmd_string:gsub("${file}", file)
      cmd_string = cmd_string:gsub("${file_basename}", file_basename)
      cmd_string = cmd_string:gsub("${workspaceFolder}", vim.fn.getcwd())
      
      return {
        name = config.name,
        cmd = cmd_string,
        cwd = config.cwd or vim.fn.expand("%:p:h"),
        components = config.components,
      }
    end,
    condition = {
      filetype = { ft },
    },
  })
end

-- 检测常见构建系统并添加自定义任务
local build_systems = {
  -- Make
  {
    name = "Make 构建",
    builder = function()
      return {
        name = "Make 构建",
        cmd = { "make" },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.filereadable("Makefile") == 1
      end,
    },
  },
  -- CMake
  {
    name = "CMake 构建",
    builder = function()
      return {
        name = "CMake 构建",
        cmd = { "mkdir -p build && cd build && cmake .. && make" },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.filereadable("CMakeLists.txt") == 1
      end,
    },
  },
  -- Cargo (Rust)
  {
    name = "Cargo 构建",
    builder = function()
      return {
        name = "Cargo 构建",
        cmd = { "cargo", "build" },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.filereadable("Cargo.toml") == 1
      end,
    },
  },
  -- NPM
  {
    name = "NPM 构建",
    builder = function()
      return {
        name = "NPM 构建",
        cmd = { "npm", "run", "build" },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.filereadable("package.json") == 1
      end,
    },
  },
  -- Go mod
  {
    name = "Go 构建",
    builder = function()
      return {
        name = "Go 构建",
        cmd = { "go", "build", "." },
        components = { "default" },
      }
    end,
    condition = {
      callback = function()
        return vim.fn.filereadable("go.mod") == 1
      end,
    },
  },
}

-- 注册构建系统模板
for _, template in ipairs(build_systems) do
  overseer.register_template(template)
end

-- 添加快捷键
vim.keymap.set("n", "<F9>", ":OverseerRun<CR>", { silent = true, desc = "运行任务" })
vim.keymap.set("n", "<F10>", ":OverseerToggle<CR>", { silent = true, desc = "切换任务面板" })
vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>", { silent = true, desc = "运行任务" })
vim.keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { silent = true, desc = "切换任务面板" })
vim.keymap.set("n", "<leader>ob", ":OverseerBuild<CR>", { silent = true, desc = "构建" })
vim.keymap.set("n", "<leader>oc", ":OverseerRunCmd<CR>", { silent = true, desc = "运行自定义命令" })
vim.keymap.set("n", "<leader>ol", ":OverseerLoadBundle<CR>", { silent = true, desc = "加载任务集" })
vim.keymap.set("n", "<leader>os", ":OverseerSaveBundle<CR>", { silent = true, desc = "保存任务集" })

-- 添加对 AsyncRun 的集成
vim.cmd([[
if exists(':AsyncRun')
  " 运行单个文件
  command! -bang -nargs=* -complete=file -bar AsyncRunFile 
        \ :call asyncrun#run('<bang>', 
        \                      {'mode': 'term', 'pos': 'bottom', 'rows': 10},
        \                      expand('%:p'))
endif
]])

-- 创建表示当前文件的快捷命令
vim.api.nvim_create_user_command("RunFile", function()
  local filetype = vim.bo.filetype
  if filetypes[filetype] then
    overseer.run_template({ name = filetypes[filetype].name })
  else
    vim.notify("没有为当前文件类型定义运行方式: " .. filetype, vim.log.levels.WARN)
  end
end, {})

-- 设置 F5 键运行当前文件
vim.keymap.set("n", "<F7>", ":RunFile<CR>", { silent = true, desc = "运行当前文件" })