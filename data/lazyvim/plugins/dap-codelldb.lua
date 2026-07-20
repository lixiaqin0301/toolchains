-- Use the codelldb on PATH (a locally built, glibc 2.17 compatible one) instead of
-- the mason-managed prebuilt binary, which needs GLIBC_2.35 and exits 101 here.
-- liblldb is resolved via the symlink at .../lldb/lib/liblldb.so, so no --liblldb
-- is needed. NOTE: mason still lists codelldb in ensure_installed (via the clangd
-- extra), so if it manages to install its own copy it may shadow the PATH one.
-- The c/cpp configurations come from lazyvim.plugins.extras.lang.clangd.
return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      require("dap").adapters.codelldb = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }
    end,
  },
}
