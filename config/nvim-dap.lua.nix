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
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        return coroutine.create(function(coro)
          local opts = {}
          pickers
            .new(opts, {
              prompt_title = "Path to executable",
              finder = finders.new_oneshot_job({ "${pkgs.fd}/bin/fd", "--extension", "py" }, {}),
              sorter = conf.generic_sorter(opts),
              attach_mappings = function(buffer_number)
                actions.select_default:replace(function()
                  actions.close(buffer_number)
                  coroutine.resume(coro, action_state.get_selected_entry()[1])
                end)
                return true
              end,
            })
            :find()
        end)
      end,
    },
    cwd = '$${workspaceFolder}'
  },
  {
    -- If you get an "Operation not permitted" error using this, try disabling YAMA:
    --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    name = "Attach to process",
    type = 'gdb',
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
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
