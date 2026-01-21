local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
  if client.name == 'gopls' then
    client.server_capabilities.semanticTokensProvider = {
      full = true,
      legend = {
        tokenTypes = { 'namespace', 'type', 'class', 'enum', 'interface', 'struct', 'typeParameter', 'parameter',
          'variable', 'property', 'enumMember', 'event', 'function', 'method', 'macro', 'keyword', 'modifier', 'comment',
          'string', 'number', 'regexp', 'operator', 'decorator' },
        tokenModifiers = { 'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async',
          'modification', 'documentation', 'defaultLibrary' }
      }
    }
  end
end

lspconfig.gopls.setup({
  --on_attach = on_attach,
  settings = {
    gopls = {
      buildFlags = { "-tags=integration,endtoendtest,integration_snowflake" },
      usePlaceholders = true,
      semanticTokens = true
    }
  }
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(ev)
    vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = 'Variable' })
    vim.api.nvim_set_hl(0, 'goImportString', { fg = 'green' })
    vim.api.nvim_set_hl(0, '@lsp.type.namespace.go', { link = 'Include' })
    vim.api.nvim_set_hl(0, '@lsp.type.function', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.type.string', { link = 'String' })
  end
})
