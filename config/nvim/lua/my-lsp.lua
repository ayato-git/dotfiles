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
local border = {
  {"🭽", "FloatBorder"}, {"▔", "FloatBorder"}, {"🭾", "FloatBorder"}, {"▕", "FloatBorder"},
  {"🭿", "FloatBorder"}, {"▁", "FloatBorder"}, {"🭼", "FloatBorder"}, {"▏", "FloatBorder"},
}
-- override LSP floating window settings
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

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


vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')           -- カーソル下の変数の情報を表示
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')      -- コード整形
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')      -- カーソル下の変数をコード内で参照している箇所を一覧表示
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')      -- 定義ジャンプ
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')     -- 宣言ジャンプ
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')  -- 実装ジャンプ
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>') -- 定義ジャンプ
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')          -- 変数のリネーム
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')     -- 修正作業の候補を表示(LanguageServerによって異なる)
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
