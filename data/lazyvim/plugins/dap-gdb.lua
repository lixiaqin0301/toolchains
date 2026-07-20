-- Use gdb's native DAP interface instead of codelldb.
-- codelldb's prebuilt binary requires a newer glibc than CentOS 7 (2.17) provides,
-- which causes it to exit 101 (libz.so.1 / GLIBC_2.35 errors). gdb >= 14 ships a
-- built-in DAP adapter (`gdb --interpreter=dap`) and is built for this system,
-- so it sidesteps the glibc mismatch entirely.
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")

    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }

    for _, lang in ipairs({ "c", "cpp" }) do
      dap.configurations[lang] = {
        {
          name = "Launch (gdb)",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Attach to process (gdb)",
          type = "gdb",
          request = "attach",
          pid = function()
            return vim.fn.input("PID to attach: ")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end,
}
