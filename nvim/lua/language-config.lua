vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  command = "set shiftwidth=2 smarttab expandtab tabstop=8 softtabstop=0"
})
