local lspconfig = require('lspconfig')
local lsp_settings = {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  -- settings = {}
}
local servers = {
  -- TODO: :ExlintFixAll コマンドについて調べる
  'cssls', 'eslint', 'html', 'jsonls', -- pnpm install --global vscode-langservers-extracted
  'cssmodules_ls', -- pnpm install --global cssmodules-language-server
  'stylelint_lsp', -- pnpm install --global stylelint-lsp
  'tailwindcss',   -- pnpm install --global @tailwindcss/language-server
  'quick_lint_js', -- pnpm install --global quick-lint-js
  'tsserver',      -- pnpm install --global typescript typescript-language-server
  'svelte',        -- pnpm install --global typescript svelte-language-server
  'bashls',        -- pnpm install --global bash-language-server
  'dockerls',      -- pnpm install --global dockerfile-language-server-nodejs
  'intelephense',  -- pnpm install --global intelephense
  'vimls',         -- pnpm install --global vim-language-server
  'sqlls',         -- pnpm install --global sql-language-server
  'marksman',      -- brew install marksman
  'lua_ls',        -- brew install lua-language-server
  -- 'docker_compose_language_service', pnpm install --global @microsoft/compose-language-service
  -- 'phpactor', ready to use phpactor
  -- 'psalm' not installed yet for PHP
}

-- TODO: PHPのlanguage-serverがautostartしない。ファイルを再度開くか、:LspStartすると問題ない
for _, lsp in ipairs(servers) do
  -- if lsp == 'intelephense' then
  --   -- see https://github.com/bmewburn/vscode-intelephense/blob/v1.9.5/package.json
  --   -- see contributes.configuration.properties
  --   lsp_settings.settings = {
  --     ['intelephense'] = {
  --       stubs = {
  --         "wordpress"
  --       }
  --     }
  --   }
  -- end

  lspconfig[lsp].setup(lsp_settings)
end
