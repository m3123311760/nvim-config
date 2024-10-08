vim.cmd([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd InsertLeave,TextChanged * silent! wall
  ]])
