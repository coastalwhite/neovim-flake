# vim: ft=lua
{ pkgs }:
''
local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define('DapStopped', { text ='▶️', texthl = "", linehl = "", numhl = ""})

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
''
