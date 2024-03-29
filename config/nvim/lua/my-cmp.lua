local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require('lspkind')
local my_keymap = require("my-keymap.nvim-cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "rg" },
    { name = "luasnip" },
    { name = 'look', keyword_length = 2,
      option = { convert_case = true, loud = true }
    },
    { name = "cmp-tw2css" },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        ["nvim_lsp"]   = "\u{f121}",
        ["path"]       = "",
        ["buffer"]     = "\u{ebd0}",
        ["cmdline"]    = "\u{e7c5}",
        ["rg"]         = "\u{f002}",
        ["luasnip"]    = "\u{eb66}",
        ["look"]       = "\u{f100d}",
        ["cmp-tw2css"] = "\u{f13ff}"
      })
    })
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

-- `/` cmdline setup.
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = 'path' } },
    { { name = 'cmdline' } }
  )
})
