-- nvim-dap
-- 1. BreakPointを打ってプラグイン起動
-- 2. DapContinueでデバッガ起動 (待機状態になる)
-- 3. ローカル環境をブラウザで開く (BreakPointを打った部分を含むコードを実行する)
-- 4. デバッガに実行時の情報が届く
vim.keymap.set('n', '<F5>',      '<cmd>DapContinue<CR>')
vim.keymap.set('n', '<F10>',     '<cmd>DapStepOver<CR>')
vim.keymap.set('n', '<F11>',     '<cmd>DapStepInto<CR>')
vim.keymap.set('n', '<F12>',     '<cmd>DapStepOut<CR>')
vim.keymap.set('n', '<Leader>b', '<cmd>DapToggleBreakpoint<CR>')

-- nvim-lspconfig
vim.keymap.set('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>')           -- カーソル下の変数の情報を表示
vim.keymap.set('n', '=',         '<cmd>lua vim.lsp.buf.formatting()<CR>')      -- コード整形
vim.keymap.set('n', '<Leader>r', '<cmd>lua vim.lsp.buf.references()<CR>')      -- カーソル下の変数をコード内で参照している箇所を一覧表示
vim.keymap.set('n', 'gd',        '<cmd>Telescope lsp_definitions<CR>')         -- 定義ジャンプ
vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.lsp.buf.declaration()<CR>')     -- 宣言ジャンプ
vim.keymap.set('n', '<Leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>')  -- 実装ジャンプ
vim.keymap.set('n', '<Leader>t', '<cmd>lua vim.lsp.buf.type_definition()<CR>') -- 型定義ジャンプ
vim.keymap.set('n', '<Leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>')          -- 変数のリネーム

-- open-browser
vim.keymap.set('n', 'gw', '<Plug>(openbrowser-smart-search)')
vim.keymap.set('v', 'gw', '<Plug>(openbrowser-smart-search)')

-- telescope
vim.keymap.set('n', '<Leader>f', '<cmd>Telescope<CR>')

-- barbar
vim.keymap.set('n', '<Tab>',  '<Cmd>BufferNext<CR>', nil)
vim.keymap.set('n', '<S-Tab>','<Cmd>BufferPrevious<CR>', nil)

-- hlchunk.nvim
-- acでaround chunkと解釈できるtextobjectを設定しているので、以下の様なkeymapが増えてる事になる
-- vac dac cac yac
