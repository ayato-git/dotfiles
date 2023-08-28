local cmp = require("cmp")
local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  -- pnpm install --global vscode-langservers-extracted
  'cssls',
  'eslint', -- TODO: :ExlintFixAll コマンドについて調べる
  'html',
  'jsonls',
  -- pnpm install -g cssmodules-language-server
  'cssmodules_ls',
  -- pnpm i -g stylelint-lsp
  'stylelint_lsp',
  -- pnpm install -g @tailwindcss/language-server
  'tailwindcss',
  -- pnpm install --global quick-lint-js
  'quick_lint_js',
  -- pnpm install -g typescript typescript-language-server
  'tsserver',
  -- pnpm install -g typescript svelte-language-server
  'svelte',
  -- pnpm i -g bash-language-server
  'bashls',
  -- pnpm install --global dockerfile-language-server-nodejs
  'dockerls',
  -- pnpm install --global @microsoft/compose-language-service
  -- 'docker_compose_language_service',
  -- pnpm install -g intelephense
  'intelephense',
  -- not installed yet for PHP
  -- 'phactor', 'psalm'
  -- pnpm install -g vim-language-server
  'vimls',
  -- pnpm install -g sql-language-server
  'sqlls',
  -- brew install marksman
  'marksman',
  -- brew install lua-language-server
  'lua_ls',
}

-- TODO: PHPのlanguage-serverがautostartしない。ファイルを再度開くか、:LspStartすると問題ない
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
    { name = "rg" },
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
