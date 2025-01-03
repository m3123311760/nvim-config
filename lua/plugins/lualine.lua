--[[require('lualine').setup {
  options = {
    theme = 'tokyonight',
    icons_enabled = true,
    component_separators = { '', '' },
    section_separators = { '', '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location'  },
    },
    inactive_sections = {
      lualine_a = {  },
      lualine_b = {  },
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {  },
      lualine_z = {   }
    },
--[[    tabline = {
      lualine_a = {  },
      lualine_b = {  },
      lualine_c = { 'filename' },
      lualine_x = {  },
      lualine_y = {  },
      lualine_z = {  }
    },
   extensions = { 'fugitive', 'nvim-tree' }
}]]

require('lualine').setup{
  options = {
    theme = 'tokyonight',
  },
}
