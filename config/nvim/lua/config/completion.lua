local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require('lspkind')
local colors = require('nvim-highlight-colors')
local my_keymap = require("keymap.completion")
local my_formatter = function(entry, item)
  local color_item = colors.format(entry, { kind = item.kind })
  local lspkind_mode = "symbol_text"

  if item.kind == 'Text' or item.kind == 'Variable'  then
    lspkind_mode = "symbol"
  end

  item = lspkind.cmp_format({
    mode = lspkind_mode,
    menu = ({
      ["buffer"]     = "buff",
      ["rg"]         = "grep",
      ["luasnip"]    = "\u{eb66}",
      ["look"]       = "look",
      ["cmp-tw2css"] = "\u{f13ff}"
    })
  })(entry, item)

  if color_item.abbr_hl_group then
    item.kind_hl_group = color_item.abbr_hl_group
    item.kind = color_item.abbr
  end

  return item
end


cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    {
      name = 'path',
      option = { trailing_slash = true }
    },
    { name = "buffer" },
    {
      name = "rg",
      keyword_length = 3,
      max_item_count = 5,
    },
    { name = "luasnip" },
    {
      name = 'look',
      keyword_length = 3,
      max_item_count = 5,
      option = { convert_case = true, loud = true }
    },
    { name = "cmp-tw2css" },
  },
  formatting = { format = my_formatter },
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
  sources = {
    {
      name = 'path',
      group_index = 1,
      option = { trailing_slash = true }
    },
    {
      name = 'cmdline',
      group_index = 2,
      option = { treat_trailing_slash = false }
    }
  }
})
