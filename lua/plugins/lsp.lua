-- LSP 配置
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  vim.notify("lspconfig 模块未找到，请确保插件已正确安装")
  return
end

-- 设置按键映射
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

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

-- 固定语言服务器列表（不再用 executable 检查）
local servers = {
  "pyright",     -- Python
  "ts_ls",    -- TypeScript/JavaScript（修正 ts_ls）
  "lua_ls",      -- Lua
  "clangd",      -- C/C++
  "html",        -- HTML
  "cssls",       -- CSS
  "yamlls",      -- YAML
  "gopls"        -- Go
}

-- 初始化 Mason 和 mason-lspconfig
local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if mason_ok then mason.setup() end

if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
  })

  for _, server in ipairs(servers) do
    local opts = {
      on_attach = on_attach,
    }

    -- Lua 语言服务器特殊设置
    if server == "lua_ls" then
      opts.settings = {
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
      }
    end

    lspconfig[server].setup(opts)
  end
else
  -- fallback：无 mason 情况下直接配置
  for _, server in ipairs(servers) do
    lspconfig[server].setup({
      on_attach = on_attach,
    })
  end
end

-- ========== nvim-cmp 补全配置 ==========

local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
  local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
  local has_autopairs_cmp, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  local has_luasnip, luasnip = pcall(require, "luasnip")
  if not has_luasnip then
    vim.notify("luasnip 未安装，某些补全功能将不可用")
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        if has_luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 750 },
      { name = "codeium", priority = 600 },
      { name = "buffer", priority = 500 },
      { name = "path", priority = 250 }
    }),
    mapping = {
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_luasnip and luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif _G.check_back_space and _G.check_back_space() then
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
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
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
    experimental = {
      ghost_text = true
    }
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "buffer" }
    })
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" }
    }
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" }
    })
  })

  if has_autopairs and has_autopairs_cmp then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

