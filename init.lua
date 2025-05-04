require("plugins.plugins-setup")
require("plugins.windsurf")
require("plugins.bufferline")
require("plugins.mason")     -- 必须在 lsp 之前加载
require("plugins.lsp")
require("plugins.lualine") 
require("plugins.nvimtree")
require("plugins.clipboard") -- 添加剪贴板支持
require("plugins.autopairs") -- 自动括号
require("plugins.comment")   -- 注释功能
require("plugins.snippets")  -- 代码片段
require("plugins.cmdline")   -- 命令行补全

-- IDE 功能
require("plugins.dap-config") -- 调试支持
require("plugins.overseer")   -- 编译运行
require("plugins.symbols")    -- 代码结构大纲
require("plugins.testing")    -- 测试框架
require("plugins.ide-menu")   -- IDE 菜单

require("core.settings")
require("core.functions")
require("core.keymaps")
require("core.commands")
