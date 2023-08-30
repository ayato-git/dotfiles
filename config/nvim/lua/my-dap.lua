local dap = require('dap')
local dapui = require('dapui')
local php_debug = require('jetpack').get('vscode-php-debug').path

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { php_debug .. '/out/phpDebug.js' }
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

vim.keymap.set('n', '<F5>',  function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)

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

-- TODO: mfussenegger/nvim-dap プラグインの遅延読み込みをkeymappingに合わせる
