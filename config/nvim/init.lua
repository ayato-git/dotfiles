-- Require Neovim 0.7.0+ for new API
-- see https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
vim.g.mapleader = " " -- <Leader>をスペースキーに指定

---[[ Plugins with vim-jetpack ]]
local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end
vim.cmd.packadd('vim-jetpack')
vim.call('jetpack#begin')
vim.call('jetpack#load_toml', vim.fn.stdpath("config") .. '/jetpack.toml')
vim.call('jetpack#end')

---[[ 検索 ]]
vim.opt.ignorecase = true -- 大文字小文字を無視する
vim.opt.smartcase  = true -- 大文字が含まれる場合は大文字小文字を区別する
vim.opt.showmatch  = true -- 対応する括弧を表示する

---[[ 表示 ]]
vim.g.netrw_liststyle = 3 -- netrwでディレクトリの中身を縦に表示
vim.g.netrw_altv      = 1 -- netrwで'v'でファイルを右側に開く(デフォルトは左側)
vim.opt.number        = true -- 行番号を表示する
vim.opt.cursorline    = true -- カーソル行をハイライトする
vim.opt.cursorcolumn  = true -- カーソル列をハイライトする
vim.opt.cmdheight     = 2 -- コマンドラインの高さを2にする
vim.opt.showtabline   = 2 -- タブラインを常に表示する
vim.opt.list = true; vim.opt.listchars = {tab="¦\\ ", trail="¬"} -- タブ文字と行末の空白を表示
vim.cmd("highlight SpecialKey guibg=NONE guifg=Gray40") -- 特殊キーの色をグレーに設定

---[[ バックアップやアンドゥ関連 ]]
--    swp と undo ファイルの格納場所はneovimデフォルトに従う
vim.opt.backup    = true -- バックアップファイルを作成する
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup~//"
vim.opt.undofile  = true -- アンドゥファイルを作成する

---[[ 編集 ]]
vim.opt.clipboard = "unnamedplus" -- *と+のレジスタをOSのクリップボードとシンクロ
-- command-c / command-v / command-x でコピペ
vim.keymap.set('v', "<D-x>", '"+x',    { noremap = true })
vim.keymap.set('v', "<D-c>", '"+y',    { noremap = true })
vim.keymap.set('n', "<D-v>", '"+gP',   { noremap = true })
vim.keymap.set('i', "<D-v>", '"+gP',   { noremap = true })
vim.keymap.set('c', "<D-v>", '<C-R>+', { noremap = true })
-- vimの連続コピペできない問題 qiita.com/fukajun/items/bd97a9b963dae40b63f5
vim.keymap.set('n', '<Leader>p', '"0p', { noremap = true }) -- レジスタ0を使って連続ペースト可能にする
-- jjで挿入モードから抜ける qiita.com/hachi8833/items/7beeee825c11f7437f54#1-5
vim.keymap.set('i', 'jj', '<ESC>',   nil)
vim.keymap.set('i', 'jl', '<RIGHT>', nil)
vim.keymap.set('i', 'jk', '<ESC>O',  nil)
-- 括弧/クォートを自動補完 d.hatena.ne.jp/spiritloose/20061113/1163401194
vim.keymap.set('i', '{', '{}<LEFT>', nil)
vim.keymap.set('i', '[', '[]<LEFT>', nil)
vim.keymap.set('i', '(', '()<LEFT>', nil)
vim.keymap.set('i', '"', '""<LEFT>', nil)
vim.keymap.set('i', "'", "''<LEFT>", nil)

---[[ 自作のコマンド定義 ]]
-- 現在開いているファイルのディレクトリに移動する :CdCurrent
vim.api.nvim_create_user_command('CdCurrent', 'cd %:p:h', { nargs = 0 })
-- 垂直分割して差分表示する :VDsplit
vim.api.nvim_create_user_command('VDsplit', "vertical diffsplit <args>", { nargs = 1, complete = 'file' })


-- 補完関連のオプション
-- vim.opt.wildmenu = true; vim.opt.wildmode = {"longest", "full"}
-- インデント関連のオプション
-- vim.opt.tabstop = 2 -- タブ幅を2にする
-- vim.opt.shiftwidth = 2 -- シフト幅を2にする
-- vim.opt.expandtab = true -- タブ文字をスペースに変換する
