return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- 系统已有 /usr/bin/clangd(LLVM 21),不让 mason 再去下载它自带的 clangd
      -- (mason 走直连 github,114MB @ ~17KB/s 基本下不完)。mason=false 时
      -- lspconfig 会直接用 PATH 上的 clangd。
      clangd = { mason = false },
      -- marksman 已手动装在 PATH(lang.markdown extra 用),同样不走 mason
      marksman = { mason = false },
    },
  },
}
