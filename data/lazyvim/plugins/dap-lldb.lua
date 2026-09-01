-- Use the system lldb-dap from the local LLVM toolchain instead of codelldb.

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

  local label_fn = function(p)
    return string.format("%d  %-12s %s", p.pid, p.user, p.cmd)
  end

  -- Prefill the picker's filter with the cwd basename (e.g. "shark"), so the
  -- target is usually the top match. `opts.snacks` feeds the snacks picker's
  -- initial input; unknown opts are ignored by other providers.
  local default_pattern = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local ui_opts = {
    prompt = "Select process to attach:",
    format_item = label_fn,
  }
  if default_pattern ~= "" then
    ui_opts.snacks = { pattern = default_pattern }
  end

  -- dap runs the `pid` function inside a coroutine, so we can drive vim.ui.select
  -- directly (mirrors how require("dap.ui").pick_one works) and pass our opts.
  local choice
  local co = coroutine.running()
  if co and vim.ui and vim.ui.select then
    vim.ui.select(procs, ui_opts, function(item)
      coroutine.resume(co, item)
    end)
    choice = coroutine.yield()
  else
    -- Fallback (no coroutine / no ui.select): dap's own picker, no prefill.
    choice = require("dap.ui").pick_one(procs, ui_opts.prompt, label_fn)
  end

  if not choice then
    return dap.ABORT
  end
  return choice.pid
end

return {
  -- Disable blink.cmp in the dap-repl buffer: its lsp/path/snippets/buffer
  -- sources clutter the completion menu. nvim-dap's own omnifunc still works
  -- via <C-x><C-o>.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          ["dap-repl"] = { inherit_defaults = false },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    -- IDE-style function keys (single press), alongside LazyVim's <leader>d* maps.
    keys = {
      -- Override <leader>dt: for attach sessions, detach without killing the
      -- attached process; for launch sessions, terminate normally (kill).
      {
        "<leader>dt",
        function()
          local dap = require("dap")
          local session = dap.session()
          if session and session.config.request == "attach" then
            dap.disconnect({ terminateDebuggee = false })
          else
            dap.terminate()
          end
        end,
        desc = "Terminate (attach: detach only)",
      },
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Debug: Step Out" }, -- Shift+F11
    },
    opts = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "executable",
        command = "/home/lixq/toolchains/llvm/usr/bin/lldb-dap",
      }

      -- Swap the pid picker on the Attach config for c/cpp (defined by the clangd
      -- extra) so it lists every user's processes, not just root's.
      for _, lang in ipairs({ "c", "cpp" }) do
        local cfgs = dap.configurations[lang] or {}
        for _, cfg in ipairs(cfgs) do
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
    },
    -- Attach sessions keep only REPL in the bottom pane (dap-ui's default);
    -- Launch sessions get the console element injected on init.
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      local function setup(with_console)
        dapui.setup(vim.tbl_deep_extend("force", opts or {}, {
          layouts = {
            { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "left" },
            { elements = with_console and { "repl", "console" } or { "repl" }, size = 10, position = "bottom" },
          },
        }))
      end

      setup(false) -- default: no console

      dap.listeners.after.event_initialized["dapui_config"] = function(session)
        dapui.close({})
        if session.config.request ~= "attach" then
          -- Launch: re-setup with console, then open (scheduled so the DAP
          -- terminal buffer exists before dapui renders it).
          setup(true)
        end
        vim.schedule(function() dapui.open({}) end)
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
}
