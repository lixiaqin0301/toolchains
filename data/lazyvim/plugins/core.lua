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
    init = function()
      -- 识别 .robot 和 .resource 文件类型
      vim.filetype.add({
        extension = {
          robot = "robot",
          resource = "robot",
        },
      })
    end,
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        clangd = { mason = false },
        marksman = { mason = false },
        pyright = { mason = false },
        ruff = { mason = false },
        robotcode = {
          mason = false,
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
              result.diagnostics = vim.tbl_filter(function(diag)
                return diag.severity <= vim.diagnostic.severity.ERROR
              end, result.diagnostics)
              vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
            end,
          },
        },
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

  -- 关闭 render-markdown
  { "MeanderingProgrammer/render-markdown.nvim", enabled = false },

  -- mini.pairs：仅 insert 模式配对，不在 `:` / `/` 等命令行里自动补全成对符号
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { insert = true, command = false, terminal = false },
    },
  },

  -- 使用 catppuccin 主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
