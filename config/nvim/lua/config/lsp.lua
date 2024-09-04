local lspconfig = require('lspconfig')
local lsp_settings = {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  -- settings = {}
}
local servers = {
  ---@see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  'cssls', 'html', 'jsonls', -- pnpm install --global vscode-langservers-extracted
  'cssmodules_ls', -- pnpm install --global cssmodules-language-server
  'stylelint_lsp', -- pnpm install --global stylelint-lsp
--'tailwindcss',   -- pnpm install --global @tailwindcss/language-server
  'quick_lint_js', -- pnpm install --global quick-lint-js
--'denols',        -- Deno's built-in language server
  'ts_ls',      -- pnpm install --global typescript typescript-language-server
  'svelte',        -- pnpm install --global typescript svelte-language-server
  'bashls',        -- pnpm install --global bash-language-server
  'dockerls',      -- pnpm install --global dockerfile-language-server-nodejs
  'intelephense',  -- pnpm install --global intelephense
  'vimls',         -- pnpm install --global vim-language-server
  'sqlls',         -- pnpm install --global sql-language-server
  'marksman',      -- brew install marksman
  'lua_ls',        -- brew install lua-language-server
  -- 'docker_compose_language_service', pnpm install --global @microsoft/compose-language-service
  -- 'phpactor', ready to use phpactor
  -- 'psalm' not installed yet for PHP
}

-- override LSP floating window settings
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "double"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

for _, lsp in ipairs(servers) do
  if lsp == 'intelephense' then
    ---@see https://github.com/bmewburn/vscode-intelephense/blob/v1.9.5/package.json
    ---@see contributes.configuration.properties
    lsp_settings.settings = {
      ['intelephense'] = {
        stubs = {
          "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl", "date", "dba", "dom",
          "enchant", "exif", "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash",
          "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc",
          "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
          "pspell", "random", "readline", "Reflection", "session", "shmop", "SimpleXML", "snmp", "soap", "sockets", "sodium",
          "SPL", "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader",
          "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib",
          "wordpress"
        }
      }
    }
  end

  lspconfig[lsp].setup(lsp_settings)
end
