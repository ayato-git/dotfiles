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
