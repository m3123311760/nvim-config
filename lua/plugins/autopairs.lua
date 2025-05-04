-- 自动括号配置
local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
  vim.notify("nvim-autopairs 插件未安装")
  return
end

-- 配置自动括号
autopairs.setup({
  check_ts = true,  -- 使用treesitter检查
  ts_config = {
    lua = {'string'},  -- 不在lua字符串中添加配对括号
    javascript = {'template_string'},
    java = false,  -- 不在java字符串中添加配对
  },
  fast_wrap = {
    map = '<M-e>',  -- Alt+e 启用快速包裹
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,]]=],
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey='Comment'
  },
  -- 在某些文件类型中禁用
  disable_filetype = { "TelescopePrompt", "vim" },
})

-- 为特定符号添加规则
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

-- 在函数名后添加括号的规则
autopairs.add_rules({
  Rule("%(.*%)%s*%=$", "-> ", {"typescript", "typescriptreact", "javascript", "rust"})
    :use_regex(true)
    :set_end_pair_length(2),
})

-- 在字符串内部添加引号的规则
autopairs.add_rules({
  Rule(" ", " ")
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
  Rule("( ", " )")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  Rule("{ ", " }")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('}'),
  Rule("[ ", " ]")
    :with_pair(function() return false end)
    :with_move(function(opts)
      return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key(']')
})

-- 自动添加空格
autopairs.add_rules({
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair)
    end),
})

-- 设置配对引号规则
autopairs.add_rules({
  -- 添加单引号规则
  Rule("'", "'", {"rust", "typescript", "typescriptreact", "javascript", "javascriptreact", "python", "lua"})
    :with_pair(cond.not_before_regex("[\\w'\"]")),
    
  -- 添加双引号规则
  Rule('"', '"', {"rust", "typescript", "typescriptreact", "javascript", "javascriptreact", "python", "lua"})
    :with_pair(cond.not_before_regex('[\\w"\']')),
})