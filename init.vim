" nvim配置文件

" ================ 插件配置 ================
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-vimlsp',
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-yaml',
  \ 'coc-pyright',
  \ 'coc-go',
  \ 'coc-clangd',
  \ 'coc-java',
  \ 'coc-markdownlint',
  \ 'coc-snippets']


call plug#begin('~/.local/share/nvim/plugged')

Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'folke/tokyonight.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

call plug#end()
colorscheme tokyonight
" ==========================================

" ================ 基础配置 ================
set number " 显示行号
set tabstop=4 " 设置tab为2个空格
set shiftwidth=4 " 设置缩进为4个空格
set expandtab " 将tab转换为空格
set clipboard=unnamedplus " 设置剪切板
set signcolumn=yes " 显示诊断信息
set encoding=utf-8 " 设置编码
set updatecount=100 " 多少次保存后更新swap文件
set swapfile " 开启交换文件
set backup " 开启备份
set backupdir=~/.local/share/nvim/backup// " 备份文件目录
set directory=~/.local/share/nvim/swap// " 交换文件目录
" ==========================================

" ================ 快捷键配置 ==============
let mapleader = " "
inoremap <silent><expr> <TAB>j coc#pum#visible() ? coc#pum#next(1) : Check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <silent><expr> <TAB>u coc#pum#visible() ? coc#pum#previous(1) : "\<C-h>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <Leader>s :w<CR>
nnoremap <C-n> :NvimTreeToggle<CR> "打开/关闭文件树
nnoremap <RightMouse> "+y
nnoremap <RightMouse> "+p
inoremap <RightMouse> <Esc>"+y
" ==========================================



" ================ 函数配置 ================
function! Check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


if has ('nvim')
  inoremap <silent><expr> <C-Space> coc#refresh()
else
  inoremap <silent><expr> <C-Space> coc#refresh()
endif



if has('termguicolors')
  set termguicolors
endif



lua << EOF
require('nvim-tree').setup {
    renderer = {
        icons = {
            show = {
                    git = true,
                    folder = true,
                    file = true,
                    folder_arrow = true,
                  },
              },
          },
          actions = {
              open_file = {
                      quit_on_open = true,
                    },
                },
                on_attach = function(bufnr)
                    local api = require('nvim-tree.api')

                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
                    end

                     vim.keymap.set('n', '<CR>', api.node.open.edit, opts('打开'))
                     vim.keymap.set('n', 's', api.node.open.horizontal, opts('水平分屏打开'))
                     vim.keymap.set('n', 'v', api.node.open.vertical, opts('垂直分屏打开'))
                     vim.keymap.set('n', 't', api.node.open.tab, opts('新标签页打开'))
                end
    }


require('bufferline').setup {
    options = {
        theme = 'tokyonight',
        numbers = 'none',
        mappings = true,
        diagnostics = 'nvim_lsp',
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = 'slant',
        always_show_bufferline = true,
    },
}



require('lualine').setup {
    options = {
        theme = 'tokyonight',
        icons_enabled = true,
        section_separators = {'', ''},
        component_separators = {'', ''},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = {'fugitive'},
}
EOF
" ==========================================


