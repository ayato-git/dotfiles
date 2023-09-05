local cmp = require("cmp")
local luasnip = require("luasnip")
local my_keymap = require("my-keymap.nvim-cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "path", option = { trailing_slash = true } },
    { name = "buffer" },
    { name = "cmdline" },
    { name = "rg" },
    { name = "luasnip" },
    { name = 'look', keyword_length = 2,
      option = { convert_case = true, loud = true }
    },
  },
  mapping = cmp.mapping.preset.insert(my_keymap),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({ border = "rounded" }),
    documentation = cmp.config.window.bordered({ border = "rounded" }),
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})
