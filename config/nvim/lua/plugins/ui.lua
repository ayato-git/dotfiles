return {
  {
    "https://github.com/ray-x/starry.nvim",
    event = "VeryLazy",
    init = function () vim.cmd('colorscheme monokai') end,
    opts = { disable = { background = true } }
  },
  {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    build = ":TSUpdate",
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
  { "https://github.com/nvim-lua/plenary.nvim" },
  { "https://github.com/nvim-telescope/telescope-file-browser.nvim" },
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
  {
    "https://github.com/romgrk/barbar.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { 'BufferNext', 'BufferPrevious' },
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
    "https://github.com/lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {}
  },
  {
    "https://github.com/brenoprata10/nvim-highlight-colors",
    event = {"CursorMoved", "CursorMovedI", "CursorHold"},
    config = function()
      require('nvim-highlight-colors').turnOn()
    end,
  },
  {
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    main = 'ibl',
    version = '*',
    event = {"CursorMoved", "CursorMovedI", "CursorHold"},
    opts = {
      indent = {
        highlight = 'Whitespace'
      }
    },
  },
  -- gitcommitで以上に重くなるのでexclude_filetypesで動作しない様にしたが、
  -- 正しく適用されないバグがある様なのでプラグインの利用自体を中止
  -- {
  --   "https://github.com/shellRaining/hlchunk.nvim",
  --   event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  --   version = '*',
  --   opts = {
  --     chunk = {
  --       enable = false,
  --       textobject = "ac", -- vac でvisual around chunkと解釈できるtextobjectを設定
  --       duration = 100,
  --       delay = 10,
  --       exclude_filetypes = {
  --         gitcommit = true,
  --       }
  --     },
  --     indent = {
  --       enable = false,
  --       exclude_filetypes = {
  --         gitcommit = true,
  --       }
  --     },
  --     line_num = {
  --       enable = false,
  --       style = '#f0f0f0',
  --       exclude_filetypes = {
  --         gitcommit = true,
  --       }
  --     },
  --   },
  -- },
  {
    "https://github.com/andersevenrud/nvim_context_vt",
    event = {"CursorMoved", "CursorMovedI"},
    opts = {}
  },
}
