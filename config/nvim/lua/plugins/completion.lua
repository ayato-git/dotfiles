return {
  {
    "https://github.com/hrsh7th/nvim-cmp",
    event = {"CmdlineEnter", "InsertEnter"},
    config = function ()
      require('config.completion')
    end
  },
  {
    "https://github.com/neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
      require('config.lsp')
    end,
  },
  {
    "https://github.com/j-hui/fidget.nvim",
    version = "v1.4.5",
    event = "LspAttach",
    opts = {}
  },
  {
    "https://github.com/ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = { zindex = 50 },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    init = function () vim.diagnostic.config({ virtual_text = false }) end,
    opts = {}
  },
  {
    "https://github.com/L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    event = "InsertEnter",
  },
  { "https://github.com/onsails/lspkind.nvim" ,    event = "LspAttach"   },
  { "https://github.com/hrsh7th/cmp-nvim-lsp" ,    event = "LspAttach"   },
  { "https://github.com/hrsh7th/cmp-path" ,        event = {"CmdlineEnter", "InsertEnter"} },
  { "https://github.com/hrsh7th/cmp-buffer" ,      event = {"CmdlineEnter", "InsertEnter"} },
  { "https://github.com/hrsh7th/cmp-cmdline" ,     event = "CmdlineEnter"},
  { "https://github.com/hrsh7th/cmp-emoji" ,       event = "CmdlineEnter"},
  { "https://github.com/octaltree/cmp-look" ,      event = "InsertEnter" },
  { "https://github.com/lukas-reineke/cmp-rg" ,    event = "InsertEnter" },
  { "https://github.com/saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
  { "https://github.com/jcha0713/cmp-tw2css" ,     event = "InsertEnter" },
}
