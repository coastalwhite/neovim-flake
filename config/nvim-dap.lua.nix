# vim: ft=lua
{ pkgs }:
''
local dap = require('dap')
local dapui = require("dapui")

vim.api.nvim_set_hl(0, "red",    { fg = "#993939" }) 
vim.api.nvim_set_hl(0, "blue",   { fg = "#3D59A1" }) 
vim.api.nvim_set_hl(0, "green",  { fg = "#9ECE6A" }) 
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" }) 
vim.api.nvim_set_hl(0, "orange", { fg = "#F09000" }) 

vim.fn.sign_define('DapBreakpoint',          { text='', texthl='red',    linehl='DapBreakpoint', numhl='DapBreakpoint'  })
vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='blue',   linehl='DapBreakpoint', numhl='DapBreakpoint'  })
vim.fn.sign_define('DapBreakpointRejected',  { text='', texthl='orange', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint',            { text='', texthl='green',  linehl='DapLogPoint',   numhl= 'DapLogPoint'   })
vim.fn.sign_define('DapStopped',             { text='', texthl='yellow', linehl='DapStopped',    numhl= 'DapStopped'   })

dap.adapters.gdb = {
  type = "executable",
  command = "rust-gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.rust = {
  {
    name = 'Launch a Python Script in GDB',
    type = 'gdb',
    request = 'launch',
    program = 'python3',
    args = {
      function()
        return vim.fn.input('Path to Python Script: ', vim.fn.getcwd() .. '/', 'file')
      end,
    },
    cwd = '$${workspaceFolder}'
  },
}

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
''
