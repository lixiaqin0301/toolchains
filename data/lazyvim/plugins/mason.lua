return {
  "mason-org/mason.nvim",
  -- 覆盖 LazyVim 默认 config：去掉启动时的 mr.refresh()。
  -- 它每次启动都请求 api.mason-registry.dev 检查 registry,本机网络到不了会一直挂住 curl。
  -- 需要 mason 的工具都已在 PATH(codelldb 见 dap-codelldb.lua、clangd 见 lsp.lua),
  -- 无需自动安装。想装时手动 :MasonInstall <tool> 即可(那时才联网)。
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}
