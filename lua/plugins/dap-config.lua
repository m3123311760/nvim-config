-- 调试配置
local status_ok, dap = pcall(require, "dap")
if not status_ok then
  vim.notify("nvim-dap 未安装")
  return
end

-- 加载调试 UI
local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  vim.notify("nvim-dap-ui 未安装")
  return
end

-- 加载虚拟文本
local ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
if ok then
  dap_vt.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
  }
end

-- 设置断点图标
vim.fn.sign_define('DapBreakpoint', {
  text = '🔴',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition', {
  text = '🟠',
  texthl = 'DapBreakpointCondition',
  linehl = 'DapBreakpointCondition',
  numhl = 'DapBreakpointCondition'
})
vim.fn.sign_define('DapLogPoint', {
  text = '📝',
  texthl = 'DapLogPoint',
  linehl = 'DapLogPoint',
  numhl = 'DapLogPoint'
})
vim.fn.sign_define('DapStopped', {
  text = '⏸️',
  texthl = 'DapStopped',
  linehl = 'DapStopped',
  numhl = 'DapStopped'
})
vim.fn.sign_define('DapBreakpointRejected', {
  text = '❌',
  texthl = 'DapBreakpointRejected',
  linehl = 'DapBreakpointRejected',
  numhl = 'DapBreakpointRejected'
})

-- 配置调试 UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
})

-- 当开始/结束调试时自动打开/关闭 UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- 配置 Python 调试器
local dap_python_ok, dap_python = pcall(require, "dap-python")
if dap_python_ok then
  -- 尝试查找 Python 解释器
  local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "/usr/bin/python3"
  dap_python.setup(python_path)
  
  -- 添加测试支持
  dap_python.test_runner = 'pytest'
end

-- 配置 Go 调试器
local dap_go_ok, dap_go = pcall(require, "dap-go")
if dap_go_ok then
  dap_go.setup()
end

-- 配置 Lua 调试器
local has_lua_dbg, lua_dbg = pcall(require, "osv")
if has_lua_dbg then
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
  end
end

-- 键位映射
local keymap = vim.keymap.set
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true, desc = "调试: 继续" })
keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true, desc = "调试: 单步跳过" })
keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true, desc = "调试: 单步进入" })
keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true, desc = "调试: 单步跳出" })
keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true, desc = "调试: 切换断点" })
keymap("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('断点条件: '))<CR>", { silent = true, desc = "调试: 设置条件断点" })
keymap("n", "<leader>dl", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('日志点消息: '))<CR>", { silent = true, desc = "调试: 设置日志点" })
keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { silent = true, desc = "调试: 打开REPL" })
keymap("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>", { silent = true, desc = "调试: 运行测试" })

-- UI 相关键位映射
keymap("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { silent = true, desc = "调试: 切换UI" })
keymap("n", "<leader>de", ":lua require'dapui'.eval()<CR>", { silent = true, desc = "调试: 求值表达式" })
keymap("v", "<leader>de", ":lua require'dapui'.eval()<CR>", { silent = true, desc = "调试: 求值选中表达式" })

-- 自动检测并加载项目特定的调试配置
local function load_project_debugconfig()
  local project_config = vim.fn.getcwd() .. "/.nvim/debug.lua"
  if vim.fn.filereadable(project_config) == 1 then
    dofile(project_config)
  end
end

load_project_debugconfig()

-- 从 mason 自动安装调试适配器
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if mason_registry_ok then
  local debug_adapters = {
    "debugpy",       -- Python
    "delve",         -- Go
    "codelldb",      -- C, C++, Rust
    "js-debug-adapter", -- JavaScript, TypeScript
    "node-debug2-adapter", -- Node.js
  }
  
  for _, adapter in ipairs(debug_adapters) do
    if not mason_registry.is_installed(adapter) then
      vim.notify("Installing debug adapter: " .. adapter)
      mason_registry.get_package(adapter):install()
    end
  end
end