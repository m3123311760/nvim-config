-- 测试框架配置
local status_ok, neotest = pcall(require, "neotest")
if not status_ok then
  vim.notify("neotest 未安装")
  return
end

-- 检查语言适配器是否可用
local adapters = {}

-- Python 测试
local has_neotest_python, neotest_python = pcall(require, "neotest-python")
if has_neotest_python then
  table.insert(adapters, neotest_python({
    dap = { justMyCode = false },
    pytest_discover_instances = true,
    runner = "pytest",
  }))
end

-- Go 测试
local has_neotest_go, neotest_go = pcall(require, "neotest-go")
if has_neotest_go then
  table.insert(adapters, neotest_go({
    args = { "-v" },
  }))
end

-- 基本配置
neotest.setup({
  adapters = adapters,
  discovery = {
    enabled = true,
  },
  diagnostic = {
    enabled = true,
  },
  floating = {
    border = "rounded",
    max_height = 0.6,
    max_width = 0.8,
    options = {}
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestSelectedWin",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown",
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✗",
    final_child_indent = " ",
    final_child_prefix = "└",
    non_collapsible = "─",
    passed = "✓",
    running = "⟳",
    skipped = "",
    unknown = "?"
  },
  output = {
    enabled = true,
    open_on_run = true,
  },
  run = {
    enabled = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120
    }
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      debug = "d",
      debug_marked = "D",
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      jumpto = "i",
      mark = "m",
      output = "o",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t"
    },
  }
})

-- 设置传统测试工具 vim-test
vim.g['test#strategy'] = 'neovim'
vim.g['test#neovim#term_position'] = 'belowright'
vim.g['test#neovim#term_height'] = 15

-- 添加键位映射
vim.keymap.set("n", "<leader>tt", function() neotest.run.run() end, { desc = "测试: 运行最近的测试" })
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "测试: 运行当前文件" })
vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "测试: 切换摘要" })
vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "测试: 打开输出" })
vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, { desc = "测试: 切换输出面板" })
vim.keymap.set("n", "<leader>tm", function() neotest.run.run({ suite = true }) end, { desc = "测试: 运行所有测试" })
vim.keymap.set("n", "<leader>td", function() neotest.run.run({ strategy = "dap" }) end, { desc = "测试: 调试最近的测试" })
vim.keymap.set("n", "<leader>ts", function() neotest.run.stop() end, { desc = "测试: 停止测试" })

-- vim-test 映射
vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", { silent = true, desc = "测试: 运行最近的测试" })
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { silent = true, desc = "测试: 运行上一次的测试" })
vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", { silent = true, desc = "测试: 访问上一次的测试" })