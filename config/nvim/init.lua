-- マップリーダーをスペースに設定
vim.g.mapleader = " "
-- 検索時のオプション
vim.opt.ignorecase = true -- 大文字小文字を無視する
vim.opt.smartcase = true -- 大文字が含まれる場合は大文字小文字を区別する
vim.opt.showmatch = true -- 対応する括弧を表示する
vim.opt.hlsearch = true -- 検索した単語をハイライトする
-- 表示関連のオプション
vim.opt.number = true -- 行番号を表示する
vim.opt.cursorline = true -- カーソル行をハイライトする
vim.opt.cursorcolumn = true -- カーソル列をハイライトする
vim.opt.lazyredraw = true -- スクロール時に再描画しない
vim.opt.cmdheight = 2 -- コマンドラインの高さを2にする
vim.opt.showtabline = 2 -- タブラインを常に表示する
vim.opt.laststatus = 2 -- ステータスラインを常に表示する
vim.opt.showcmd = true -- 入力中のコマンドを表示する
-- 補完関連のオプション
-- vim.opt.wildmenu = true; vim.opt.wildmode = {"longest", "full"}
-- インデント関連のオプション
vim.opt.tabstop = 2 -- タブ幅を2にする
vim.opt.shiftwidth = 2 -- シフト幅を2にする
vim.opt.expandtab = true -- タブ文字をスペースに変換する
vim.opt.autoindent = true -- 自動インデントを有効にする
-- タブ文字と行末の空白を表示
vim.opt.list = true; vim.opt.listchars = {tab="¦\\ ", trail="¬"}
-- 特殊キーの色をグレーに設定
vim.cmd("highlight SpecialKey guibg=NONE guifg=Gray40")
-- バックアップやアンドゥ関連のオプション
vim.opt.directory = os.getenv("HOME") .. "/.vim/swp" -- スワップファイルの保存先を設定する
vim.opt.backup = true -- バックアップファイルを作成する
vim.opt.backupdir = os.getenv("HOME") .. "/.vim/backup~" -- バックアップファイルの保存先を設定する
vim.opt.undofile = true -- アンドゥファイルを作成する
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undo" -- アンドゥファイルの保存先を設定する
vim.opt.viminfo:append({ 'c,n~/.vim/viminfo.txt' }) -- Vim情報ファイルの保存先と内容を設定する
-- vim.cmd("set viminfo+=c,n~/.vim/viminfo.txt") -- Vim情報ファイルの保存先と内容を設定する
-- vimの連続コピペできない問題 qiita.com/fukajun/items/bd97a9b963dae40b63f5
vim.api.nvim_set_keymap('n', '<Leader>p', '"0p', { noremap = true }) -- レジスタ0を使って連続ペースト可能にする
-- jjで挿入モードから抜ける qiita.com/hachi8833/items/7beeee825c11f7437f54#1-5
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { silent = true })
vim.api.nvim_set_keymap('i', 'jl', '<RIGHT>', { silent = true })
vim.api.nvim_set_keymap('i', 'jk', '<ESC>O', { silent = true })
-- 括弧/クォートを自動補完 d.hatena.ne.jp/spiritloose/20061113/1163401194
vim.api.nvim_set_keymap('i', '{', '{}<LEFT>', {})
vim.api.nvim_set_keymap('i', '[', '[]<LEFT>', {})
vim.api.nvim_set_keymap('i', '(', '()<LEFT>', {})
vim.api.nvim_set_keymap('i', '"', '""<LEFT>', {})
vim.api.nvim_set_keymap('i', "'", "''<LEFT>", {})
-- 自作のコマンド定義
vim.cmd("command! -nargs=0 CdCurrent cd %:p:h") -- 現在開いているファイルのディレクトリに移動する :CdCurrent
vim.cmd("command! -nargs=1 -complete=file VDsplit vertical diffsplit <args>") -- 垂直分割して差分表示する :VDsplit
vim.api.nvim_command('autocmd InsertEnter * setlocal relativenumber!') -- insert modeで相対行番号を表示して行移動等のコマンドの補助
vim.api.nvim_command('autocmd InsertLeave * setlocal relativenumber!')
vim.g.netrw_liststyle = 3 -- netrwでディレクトリの中身を縦に表示
vim.g.netrw_altv = 1 -- netrwで'v'でファイルを開くときは右側に。(デフォルトは左側)
