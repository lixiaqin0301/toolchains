-- 让 nvim-treesitter 从本地镜像(离线)取各语言 grammar 源码,而不是 curl github。
--
-- 原理:install.lua 的 do_download 用 `curl -L <url>/archive/<revision>.tar.gz` 下载源码,
-- curl 支持 file:// 协议。这里在安装前把每个 parser 的 install_info.url 从
-- https://github.com/OWNER/REPO 改写成 file://<BASE>/OWNER/REPO,拼出的
-- <url>/archive/<rev>.tar.gz 就命中本地镜像里的同名 tarball,后续解压/编译流程原样复用。
--
-- 镜像布局(用 /tmp/ts-mirror-fetch.sh 在能上网处填充):
--   <BASE>/OWNER/REPO/archive/<revision>.tar.gz   (就是 github 的 archive tarball 原样)
--
-- 仅当本地 tarball 存在时才改写 → 没镜像的 parser 自动回退 github 源,优雅降级。
local BASE = "/share-rd/cdn_prd_cache/lixq/src"

local function use_local_mirror()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return
  end
  for _, cfg in pairs(parsers) do
    local ii = type(cfg) == "table" and cfg.install_info
    local url = type(ii) == "table" and ii.url
    if type(url) == "string" then
      local rel = url:match("^https://github%.com/(.*)$")
      local rev = ii.revision or ii.branch or "main"
      if rel then
        local tarball = string.format("%s/%s/archive/%s.tar.gz", BASE, rel, rev)
        if vim.uv.fs_stat(tarball) then
          ii.url = "file://" .. BASE .. "/" .. rel
        end
      end
    end
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- 安装(build)在 LazyVim 的 config 里触发,opts 在其之前解析,这里改写最稳。
    use_local_mirror()
    -- :TSUpdate / reload_parsers 会重读 parsers.lua(恢复 github url),重新套用镜像。
    vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate", callback = use_local_mirror })
    return opts
  end,
}
