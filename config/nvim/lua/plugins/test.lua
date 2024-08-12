return {
  {
    "https://github.com/vim-jp/vimdoc-ja",
    event = "CmdlineEnter",
    init = function() vim.opt.helplang = "ja,en" end,
  },
  { "https://github.com/nvim-lua/plenary.nvim" },
  {
    "https://github.com/romgrk/barbar.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = { icons = { filetype = { enabled = false } } },
  },
  {
    "https://github.com/tiagovla/scope.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      hooks = {
        pre_tab_leave = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
        end,
        post_tab_enter = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
        end,
      },
    },
  },
  {
    "https://github.com/ray-x/starry.nvim",
    event = "VeryLazy",
    init = function () vim.cmd('colorscheme monokai') end,
    opts = { disable = { background = true } }
  },
  {
    "https://github.com/lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {}
  },
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    build = ":TSupdate",
    init = function()
      vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/treesitter')
    end,
    main = 'nvim-treesitter.configs',
    opts = {
      parser_install_dir = vim.fn.stdpath('data') .. '/treesitter',
      auto_install = true,
      highlight = { enable = true, },
      indent = { enable = true, },
    }
  },
  {
    "https://github.com/brenoprata10/nvim-highlight-colors",
    event = {"CursorMoved", "CursorMovedI", "CursorHold"},
    config = function()
      require('nvim-highlight-colors').turnOn()
    end,
  },
  {
    "https://github.com/shellRaining/hlchunk.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      chunk = {
        enable = true,
        textobject = "cl", -- vcl でvisual chunk linesと解釈できるtextobjectを設定
        duration = 100,
        delay = 10,
      },
      indent = { enable = true },
      line_num = { enable = true, style = '#f0f0f0' },
    },
  },
  {
    "https://github.com/andersevenrud/nvim_context_vt",
    event = {"CursorMoved", "CursorMovedI"},
    opts = {}
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
    "https://github.com/nvim-telescope/telescope.nvim",
    version = "0.1.8",
    cmd = "Telescope",
    event = "CmdlineEnter",
    config = function ()
      local telescope = require('telescope')
      telescope.setup({
        extensions = {
          file_browser = {
            hijack_netrw = true
          }
        }
      })
      telescope.load_extension('file_browser')
    end
  },
  { "https://github.com/nvim-telescope/telescope-file-browser.nvim" },
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
    "https://github.com/rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    init = function()
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  },
  {
    "https://github.com/previm/previm",
    ft = {"markdown", "rst", "mkd", "md"},
    cmd = "PrevimOpen",
    dependencies = "open-browser.vim",
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
    "https://github.com/xdebug/vscode-php-debug",
    version = "v1.35.0",
    cmd = {'DapToggleBreakpoint'},
    build = [[
      mise use node@16
      npm install
      npm run build
    ]],
  },
}
