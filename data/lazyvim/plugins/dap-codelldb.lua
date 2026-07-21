-- Use the codelldb on PATH (a locally built, glibc 2.17 compatible one) instead of
-- the mason-managed prebuilt binary, which needs GLIBC_2.35 and exits 101 here.
-- liblldb is resolved via the symlink at .../lldb/lib/liblldb.so, so no --liblldb
-- is needed. NOTE: mason still lists codelldb in ensure_installed (via the clangd
-- extra), so if it manages to install its own copy it may shadow the PATH one.
-- The c/cpp configurations come from lazyvim.plugins.extras.lang.clangd; we only
-- override the Attach entry's pid picker below.

-- List processes of ALL users (root nvim + attaching to another user's process).
-- dap's built-in require("dap.utils").pick_process runs `ps ah -U $USER`, which
-- only shows the current user's processes, hiding e.g. a `sharklet` worker.
local function pick_process_all()
  local dap = require("dap")
  local out = vim.fn.systemlist({ "ps", "-eo", "pid=", "-o", "user=", "-o", "args=" })
  if vim.v.shell_error ~= 0 then
    vim.notify("pick_process_all: `ps` failed", vim.log.levels.ERROR)
    return dap.ABORT
  end

  local nvim_pid = vim.fn.getpid()
  local procs = {}
  for _, line in ipairs(out) do
    local pid, user, cmd = line:match("^%s*(%d+)%s+(%S+)%s+(.*)$")
    pid = tonumber(pid)
    if pid and pid ~= nvim_pid and cmd and cmd ~= "" then
      table.insert(procs, { pid = pid, user = user, cmd = cmd })
    end
  end

  local choice = require("dap.ui").pick_one(
    procs,
    "Select process to attach:",
    function(p) return string.format("%d  %-12s %s", p.pid, p.user, p.cmd) end
  )
  if not choice then
    return dap.ABORT
  end
  return choice.pid
end

return {
  {
    "mfussenegger/nvim-dap",
    -- IDE-style function keys (single press), alongside LazyVim's <leader>d* maps.
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Debug: Step Out" }, -- Shift+F11
    },
    opts = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Swap the pid picker on the Attach config for c/cpp (defined by the clangd
      -- extra) so it lists every user's processes, not just root's.
      for _, lang in ipairs({ "c", "cpp" }) do
        for _, cfg in ipairs(dap.configurations[lang] or {}) do
          if cfg.request == "attach" and cfg.pid ~= nil then
            cfg.pid = pick_process_all
          end
        end
      end
    end,
  },
  {
    -- Disable all inline variable virtual text during debugging.
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      -- Rebuild the dap-ui windows at their default sizes (fixes layout that got
      -- squished after toggling neo-tree with <leader>e, etc.).
      { "<leader>dR", function() require("dapui").open({ reset = true }) end, desc = "Reset DAP UI layout" },
      -- Toggle the whole UI (LazyVim also binds <leader>du; kept here for discoverability).
      { "<leader>dU", function() require("dapui").toggle({ reset = true }) end, desc = "Toggle DAP UI (reset)" },
      -- Float the value/scope of the symbol under cursor (n) or the selection (x).
      { "<leader>dv", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "x" }, desc = "Eval (float, enter)" },
    },
  },
}
