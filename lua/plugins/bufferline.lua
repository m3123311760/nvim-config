require('bufferline').setup {
  options = {
    numbers = 'none',
    mappings = true,
    diagnostics = 'nvim_lsp',
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    separator_style = 'slash',
    always_show_bufferline = true,
    enforce_regular_tabs = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      },
    },
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
  },
}
