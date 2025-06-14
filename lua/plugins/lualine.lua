-- Lualine 状态栏配置
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify("lualine.nvim 未安装")
  return
end

-- 添加一个自定义组件，显示并提供点击 Mason 的按钮
local function mason_button()
  return "Mason(m)"
end

-- 添加一个自定义组件，显示编译运行按钮
local function run_button()
  return "运行(F7)"
end

-- 添加一个自定义组件，显示调试按钮
local function debug_button()
  return "调试(F5)"
end

-- 状态栏配置
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {
      -- 右侧按钮区域
      { mason_button, color = {fg = "yellow"} },
      { run_button, color = {fg = "green"} },
      { debug_button, color = {fg = "red"} },
      'location'
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
