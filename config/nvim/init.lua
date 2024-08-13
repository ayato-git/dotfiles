-- TODO: InsertModeのctrl-oで一度だけノーマルモードのコマンドを入力できるのを覚える
-- Require Neovim 0.7.0+ for new API
-- see https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
vim.loader.enable()
vim.g.mapleader = " " -- <Leader>をスペースキーに指定

---[[ Bootstrap lazy.nvim ]]
vim.cmd("syntax off")
require("config.lazy")

---[[ 検索 ]]
vim.opt.ignorecase = true -- 大文字小文字を無視する
vim.opt.smartcase  = true -- 大文字が含まれる場合は大文字小文字を区別する
vim.opt.inccommand = 'split' -- 置換をプレビューウィンドウで表示

---[[ Network file Reader and Writer ]]
vim.g.netrw_liststyle = 3    -- ディレクトリの中身をツリー表示する
vim.g.netrw_preview   = 1    -- 'p'でファイルのプレビューウィンドウを垂直分割で開く
vim.g.netrw_winsize   = 30   -- ウィンドウサイズを横30%に限定(プレビューが70%)

---[[ 表示 ]]
vim.opt.termguicolors = true -- ターミナルで起動しても24bit色で表示する
vim.opt.splitright    = true -- :vertical や :vsplit でウィンドウを右側に表示する
vim.opt.laststatus    = 3    -- ステータスラインをsplitせずに下部に表示する
vim.opt.number        = true -- 行番号を表示する
vim.opt.signcolumn    = 'yes:1' -- 行ごとのサインを表示する
vim.opt.cursorline    = true -- カーソル行をハイライトする
vim.opt.cursorcolumn  = true -- カーソル列をハイライトする
vim.opt.synmaxcol     = 200  -- 1行に200文字までハイライトする(負荷対策)
vim.opt.showmatch     = true -- 対応する括弧を表示する
vim.opt.tabstop       = 2    -- タブ文字をスペース2文字の長さで表示
vim.opt.shiftwidth    = 0    -- 自動インデントでtabstopの値を参照
vim.opt.list          = true
vim.opt.listchars:append "trail:¬" -- 行末の空白を可視化
vim.opt.listchars:append "tab:¦-" -- タブ文字を可視化

---[[ バックアップやアンドゥ関連 ]]
--- swp と undo ファイルの格納場所はneovimデフォルトに従う
vim.opt.backup    = true -- バックアップファイルを作成する
-- 編集ファイルの隣にバックアップファイルを作成しない
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup~//"
vim.opt.undofile  = true -- アンドゥファイルを作成する

---[[ 編集 ]]
require('keymap.vanilla')
require('keymap.plugins')

---[[ 自作のコマンド定義 ]]
-- 現在開いているファイルのディレクトリに移動する :CdCurrent
vim.api.nvim_create_user_command('CdCurrent', 'cd %:p:h', { nargs = 0 })
-- 垂直分割して差分表示する :VDsplit
vim.api.nvim_create_user_command('VDsplit', "vertical diffsplit <args>", { nargs = 1, complete = 'file' })
