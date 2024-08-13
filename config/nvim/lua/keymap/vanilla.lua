vim.keymap.set('c', "<D-v>",  '<C-R>+',  { noremap = true }) -- コマンドモードでcommand-vで貼り付け
---@see https://blog.atusy.net/2024/03/11/vim-gy-as-gui-yank/ 
vim.keymap.set('n', 'gy',  '"+y', nil)                       -- gyでクリップボード(+のレジスタ)にyankする
vim.keymap.set('v', 'gy',  '"+y', nil)                       -- gyでクリップボード(+のレジスタ)にyankする
vim.keymap.set('i', 'jj',     '<ESC>',          nil)         -- jjで挿入モードから抜ける
vim.keymap.set('i', 'jl',     '<Right>',        nil)         -- jlで1文字右に移動 ) や ' の右側に行くのに便利
vim.keymap.set('n', '<Tab>',  '<Cmd>bnext<CR>', nil)
vim.keymap.set('n', '<S-Tab>','<Cmd>bprev<CR>', nil)
