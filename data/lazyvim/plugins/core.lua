return {
  -- mason.nvim：覆盖 LazyVim 默认 config，去掉启动时的 mr.refresh()
  {
    "mason-org/mason.nvim",
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- nvim-lspconfig + clangd / marksman（均用系统 PATH，不走 mason）
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = { mason = false },
        marksman = { mason = false },
        pyright = { mason = false },
        ruff = { mason = false },
        robotcode = { mason = false },
      },
    },
  },

  -- conform.nvim：clang-format / prettier
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        objc = { "clang_format" },
        objcpp = { "clang_format" },
        cuda = { "clang_format" },
        proto = { "clang_format" },
        markdown = { "prettier" },
        robot = { "robotidy" },
      },
      formatters = {
        robotidy = {
          command = "robotidy",
          args = { "--stdin", "$FILENAME" },
          stdin = true,
        },
      },
    },
  },

  -- nvim-lint：robot 文件启用 robocop
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        robot = { "robocop" },
      },
    },
  },


  -- 关闭 render-markdown
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
}
