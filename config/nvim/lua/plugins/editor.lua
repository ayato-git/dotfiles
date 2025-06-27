return {
  {
    "https://github.com/vim-jp/vimdoc-ja",
    event = "CmdlineEnter",
    init = function() vim.opt.helplang = "ja,en" end,
  },
  {
    "https://github.com/hrsh7th/nvim-insx",
    event = "InsertEnter",
    main = 'insx.preset.standard',
    opts = {}
  },
  { "https://github.com/shinespark/vim-list2tree", cmd = "List2Tree", },
  { "https://github.com/mattn/vim-maketable", cmd = "MakeTable", },
  { "https://github.com/inotom/str2htmlentity", cmd = { "Str2HtmlEntity", "Entity2HtmlString" }, },
  {
    "https://github.com/tyru/open-browser.vim",
    keys = "<Plug>(openbrowser",
  },
  {
    "https://github.com/rhysd/devdocs.vim",
    dependencies = "open-browser.vim",
    cmd = {"DevDocs", "DevDocsUnderCursor", "DevDocsALL", "DevDocsALLUnderCursor"},
  },
  {
    "https://github.com/previm/previm",
    ft = {"markdown", "rst", "mkd", "md"},
    cmd = "PrevimOpen",
    dependencies = "open-browser.vim",
  },
  {
    "https://github.com/rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    init = function()
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  },
  {
    "https://github.com/windwp/nvim-ts-autotag",
    ft = {
      "html", "xml", "markdown",
      "php", "twig",
      "javascript", "typescript",
      "astro", "svelte", "vue", "jsx", "tsx",
    },
    event = "InsertEnter",
    opts = {}
  },
  {
    -- デバッガの利用方法は keymap.plugins にてキーマップの設定と共にコメント有
    "https://github.com/mfussenegger/nvim-dap",
    main = 'dap',
    version = '0.8.0',
    cmd = {'DapToggleBreakpoint'},
    config = function()
      require('config.dap')
    end,
  },
  {
    "https://github.com/rcarriga/nvim-dap-ui",
    main = 'dapui',
    version = 'v3.9.3',
    cmd = {'DapToggleBreakpoint'},
  },
  {
    "https://github.com/rcarriga/cmp-dap",
    main = 'cmp_dap',
    cmd = {'DapToggleBreakpoint'},
  },
  {
    "https://github.com/xdebug/vscode-php-debug",
    version = "v1.36.1",
    cmd = {'DapToggleBreakpoint'},
    build = [[
      mise use node@20
      npm install
      npm run build
    ]],
  },
}


--   TODO: 今度試してみたい
--   autosave
--   toggle comments
--   generate Document comment
--   https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--   https://daisuzu.hatenablog.com/entry/2020/12/03/003629  ## Quickfix
--   https://zenn.dev/tmrekk/articles/4380961a754287  ## Quickfix
--   https://github.com/ray-x/navigator.lua
--   https://github.com/ThePrimeagen/refactoring.nvim
--   https://github.com/glacambre/firenvim
--   https://github.com/numToStr/Comment.nvim
--   https://github.com/marilari88/twoslash-queries.nvim
--   https://github.com/unblevable/quick-scope
--   https://github.com/yuki-yano/fuzzy-motion.vim
--  
--  [[plugins]]
--  repo = "mxsdev/nvim-dap-vscode-js"
--  depends = "mfussenegger/nvim-dap"
--  hook_post_source = ""
--  
--  [[plugins]]
--  repo = "microsoft/vscode-js-debug"
--  opt = true
--  build = """
--  npm install --legacy-peer-deps
--  npx gulp vsDebugServerBundle
--  mv dist out
--  """
