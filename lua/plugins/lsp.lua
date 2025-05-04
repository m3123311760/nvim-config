-- LSP 配置
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  vim.notify("lspconfig 模块未找到，请确保插件已正确安装")
  return
end

-- 设置按键映射
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- 设置按键映射
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
end

-- 设置常用 LSP 服务器
local servers = {}

-- 检查服务器是否可用，然后添加到列表
local function add_server_if_available(server_name)
  local is_available = vim.fn.executable(server_name) == 1
  if not is_available and server_name == "lua_ls" then
    -- lua_ls 特殊检查，因为可执行文件可能叫 lua-language-server
    is_available = vim.fn.executable("lua-language-server") == 1
  end
  
  if is_available then
    table.insert(servers, server_name)
    print("LSP: " .. server_name .. " 已添加")
  else
    print("LSP: " .. server_name .. " 未找到，跳过加载")
  end
end

-- 添加常用语言服务器
add_server_if_available("pyright")    -- Python
add_server_if_available("ts_ls")      -- TypeScript
add_server_if_available("lua_ls")     -- Lua
add_server_if_available("clangd")     -- C/C++
add_server_if_available("html")       -- HTML
add_server_if_available("cssls")      -- CSS
add_server_if_available("yamlls")     -- YAML
add_server_if_available("gopls")      -- Go

-- 没有安装 LSP 服务器时给出提示
if #servers == 0 then
  vim.notify([[
没有找到任何语言服务器。如需完整的智能补全体验，建议安装以下服务器：

Python:     pip install pyright
TypeScript: npm install -g typescript-language-server typescript
Lua:        brew install lua-language-server 或 apt install lua-language-server
C/C++:      apt install clangd 或 brew install llvm
Go:         go install golang.org/x/tools/gopls@latest

使用 Mason 插件可以方便地安装所有 LSP 服务器: :MasonInstall <server-name>
  ]], vim.log.levels.INFO)
end

-- 集成 Mason 自动设置 LSP
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_status then
  mason_lspconfig.setup_handlers({
    -- 默认处理器
    function(server_name)
      lspconfig[server_name].setup({
        on_attach = on_attach,
      })
    end,
    
    -- 特定服务器的自定义配置
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
    end,
  })
else
  -- 如果没有 Mason，则使用传统方式配置
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      on_attach = on_attach,
    })
  end
end

-- 配置 nvim-cmp
local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
  -- 检查自动配对括号插件
  local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
  local has_autopairs_cmp, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  
  -- 加载 luasnip
  local has_luasnip, luasnip = pcall(require, "luasnip")
  if not has_luasnip then
    vim.notify("luasnip 未安装，某些补全功能将不可用")
  end
  
  -- 加载 cmp 补全引擎
  cmp.setup({
    -- 片段引擎设置
    snippet = {
      expand = function(args)
        if has_luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    -- 补全来源
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },    -- LSP
      { name = "luasnip", priority = 750 },      -- 代码片段
      { name = "codeium", priority = 600 },      -- Windsurf/Codeium 集成
      { name = "buffer", priority = 500 },       -- 当前缓冲区
      { name = "path", priority = 250 }          -- 文件路径
    }),
    -- 快捷键映射
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif _G.check_back_space() then
          fallback()
        else
          cmp.complete()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif has_luasnip and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      ['<Esc>'] = cmp.mapping.close(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
    },
    -- 显示设置
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    -- 格式化显示的选项
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          codeium = "[AI]",
          buffer = "[缓冲区]",
          path = "[路径]",
          cmdline = "[命令]",
          cmdline_history = "[历史]",
          calc = "[计算]",
        })[entry.source.name]
        return vim_item
      end,
    },
    -- 启用实验性的ghost_text功能
    experimental = {
      ghost_text = true  -- 显示灰色的预览文本
    }
  })
  
  -- 不同文件类型使用不同的补全源
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'buffer' },
    })
  })
  
  -- 搜索模式下使用缓冲区和当前搜索补全
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
  
  -- 命令模式下使用路径和命令补全
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline' }
    })
  })
  
  -- 如果有自动括号插件，配置与cmp的集成
  if has_autopairs and has_autopairs_cmp then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end
end

-- 注释: 之前使用的 coc.nvim 配置已移除
-- vim.g.coc_global_extensions = {
--   'coc-json',
--   'coc-vimlsp',
--   'coc-tsserver',
--   'coc-html',
--   'coc-css',
--   'coc-yaml',
--   'coc-pyright',
--   'coc-clangd',
--   'coc-snippets',
--   'coc-java',
--   'coc-go',
--   'coc-markdownlint',
-- }
