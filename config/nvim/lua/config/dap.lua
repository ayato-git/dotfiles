local dap = require('dap')
local dapui = require('dapui')
local cmp = require('cmp')

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath("data") .. '/lazy/vscode-php-debug/out/phpDebug.js'
  }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003, -- Xdebug3系は9003
    -- port = 9000, -- Xdebug2系は9000
    pathMappings = {
      ["/app"] = "${workspaceFolder}"
    }
  }
}

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Thanks to cmp-dap, nvim-cmp and nvim-dap can work together
cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
