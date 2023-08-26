local cmp = require("cmp")
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  -- pnpm install --global dockerfile-language-server-nodejs
  'dockerls',
  -- pnpm install --global vscode-langservers-extracted
  'cssls',
  'eslint', -- TODO: :ExlintFixAll コマンドについて調べる
  'html',
  'jsonls',
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = lsp_capabilities,
  }
end

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "cmdline" },
    { name = 'look', keyword_length = 2,
      option = { convert_case = true, loud = true }
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
  }),
})
