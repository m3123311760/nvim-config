local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-treesitter/nvim-treesitter'
  use { 'kyazdani42/nvim-tree.lua', requires = 'nvim-tree/nvim-web-devicons' }
  use 'akinsho/nvim-bufferline.lua'
  use 'nvim-tree/nvim-web-devicons'
  use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  
  -- 选择使用 nvim-cmp 而非 coc.nvim，避免冲突
  -- use { 'neoclide/coc.nvim', branch = 'release' }
  
  -- Windsurf.nvim (实际上是 Codeium 的一个分支)
  use {
    'Exafunction/windsurf.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp'
    },
    -- 注意：这个插件内部使用的是 codeium 模块，而不是 windsurf 模块
  }
  
  -- nvim-cmp补全框架
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-cmdline'
  use 'dmitmel/cmp-cmdline-history'  -- 命令行历史补全
  use 'hrsh7th/cmp-calc'             -- 计算器补全
  use 'nvim-lua/plenary.nvim'
  
  -- 代码片段支持
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'
  
  -- 自动括号
  use 'windwp/nvim-autopairs'
  
  -- 注释插件
  use 'numToStr/Comment.nvim'
  
  -- 剪贴板增强
  use 'ojroques/nvim-osc52'
  
  -- LSP, DAP, Linter, Formatter 安装管理器
  use {
    'williamboman/mason.nvim',
    -- 移除 run 命令，因为 MasonUpdate 可能不可用
    requires = {
      'williamboman/mason-lspconfig.nvim',      -- mason-lspconfig
      'neovim/nvim-lspconfig',                  -- lspconfig
      'jayp0521/mason-null-ls.nvim',           -- mason-null-ls
      'jose-elias-alvarez/null-ls.nvim',        -- null-ls for linting/formatting
    }
  }
  
  -- 调试支持
  use {
    'mfussenegger/nvim-dap',                -- 调试适配器协议
    requires = {
      'rcarriga/nvim-dap-ui',               -- 调试界面
      'theHamsta/nvim-dap-virtual-text',    -- 内联变量显示
      'nvim-telescope/telescope-dap.nvim',  -- telescope 集成
      'leoluz/nvim-dap-go',                 -- Go 调试
      'mfussenegger/nvim-dap-python',       -- Python 调试
      'jbyuki/one-small-step-for-vimkind',  -- Lua 调试
    }
  }
  
  -- 编译运行支持
  use {
    'stevearc/overseer.nvim',               -- 任务管理系统
    requires = {
      'skywind3000/asyncrun.vim',           -- 异步命令执行 
    }
  }
  
  -- 符号树视图
  use {
    'simrat39/symbols-outline.nvim',        -- 代码结构视图
    config = function() require('symbols-outline').setup() end
  }
  
  -- 测试支持
  use {
    'vim-test/vim-test',                    -- 测试运行器
    requires = {
      'nvim-neotest/neotest',               -- 现代测试框架
      'nvim-neotest/neotest-python',        -- Python 测试适配器
      'nvim-neotest/neotest-go',            -- Go 测试适配器
    }
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
