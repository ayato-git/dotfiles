return {
  { "https://github.com/hrsh7th/cmp-nvim-lsp" },
  {
    "https://github.com/hrsh7th/nvim-cmp",
    dependencies = {"LuaSnip", "lspkind.nvim"}, --my-cmpの設定でluasnipとlspkind.nvimを呼ぶ
    config = function() require('my-cmp') end,
  },
  {
    "https://github.com/neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {"cmp-nvim-lsp", "nvim-cmp"},
-- my-lspの設定でcmp-nvim-lspを呼び、そこで更にnvim-cmpを呼ぶ
-- nvim-lspconfigを遅延読込みしているので,LanguageServerのautostartが効かない
-- (autostartはFileType autocmdで実行されるが、VeryLazyはFileTypeより後)
-- なのでLspStartを遅延読み込み後に明示
    config = function()
      require('my-lsp')
      vim.cmd("LspStart")
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
    opts = {zindex = 50},
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
  },
  { "https://github.com/hrsh7th/cmp-path", event = "InsertEnter", },
  { "https://github.com/hrsh7th/cmp-buffer", event = "InsertEnter", },
  { "https://github.com/hrsh7th/cmp-cmdline", event = "CmdlineEnter", },
  { "https://github.com/octaltree/cmp-look", event = "InsertEnter", },
  { "https://github.com/lukas-reineke/cmp-rg", event = "InsertEnter", },
  { "https://github.com/saadparwaiz1/cmp_luasnip", event = "InsertEnter", },
  { "https://github.com/onsails/lspkind.nvim", event = "InsertEnter", },
  { "https://github.com/jcha0713/cmp-tw2css", event = "InsertEnter", },
}
