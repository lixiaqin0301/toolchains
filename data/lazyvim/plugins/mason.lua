return {
  "mason-org/mason.nvim",
  opts = {
    -- 关掉 registry 联网刷新。mason / mason-lspconfig / mason-nvim-dap 的 refresh
    -- 都读这个开关,false 时 refresh() 第一行就空转返回,不再请求 api.mason-registry.dev。
    registry_cache = { refresh = false },
  },
  config = function(_, opts)
    -- 覆盖 LazyVim 默认 config:它启动时会遍历 ensure_installed 自动 p:install(),
    -- 会联网下载 stylua/shfmt/codelldb 并卡住。这里只做 setup、不自动安装。
    -- 需要的工具都已在 PATH(codelldb 见 dap-codelldb.lua、clangd 见 lsp.lua)。
    require("mason").setup(opts)
  end,
}
