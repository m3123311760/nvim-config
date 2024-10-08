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
      quit_on_open = false,
    },
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
    end



    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('打开文件'))
    vim.keymap.set('n', 's', api.node.open.horizontal, opts('水平分割打开文件'))
    vim.keymap.set('n', 'v', api.node.open.vertical, opts('垂直分割打开文件'))
    vim.keymap.set('n', 't', api.node.open.tab, opts('新标签打开文件'))
  end
}
