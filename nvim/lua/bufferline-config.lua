vim.opt.termguicolors = true
local bl = require('bufferline')
bl.setup{
  options = {
    indicator = {
      style = 'underline',
    },
    numbers = 'ordinal',
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
  },
}

for i=1,9 do
  vim.keymap.set(
    'n',
    string.format('<leader>%d', i),
    function () bl.go_to(i, true) end,
    {noremap = true, silent = true}
  )
end
