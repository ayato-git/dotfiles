vim.keymap.set('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>')           -- カーソル下の変数の情報を表示
vim.keymap.set('n', '=',         '<cmd>lua vim.lsp.buf.formatting()<CR>')      -- コード整形
vim.keymap.set('n', '<Leader>r', '<cmd>lua vim.lsp.buf.references()<CR>')      -- カーソル下の変数をコード内で参照している箇所を一覧表示
vim.keymap.set('n', 'gd',        '<cmd>Telescope lsp_definitions<CR>')         -- 定義ジャンプ
vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.lsp.buf.declaration()<CR>')     -- 宣言ジャンプ
vim.keymap.set('n', '<Leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>')  -- 実装ジャンプ
vim.keymap.set('n', '<Leader>t', '<cmd>lua vim.lsp.buf.type_definition()<CR>') -- 型定義ジャンプ
vim.keymap.set('n', '<Leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>')          -- 変数のリネーム
