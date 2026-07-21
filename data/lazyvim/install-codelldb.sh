#!/usr/bin/env bash
#
# install-codelldb.sh — 通过公共 GitHub 镜像安装 codelldb 到 Mason 目录
#
# 背景:直连 github.com 下 release 只有 ~17KB/s,codelldb/clangd 基本下不完。
#       Mason 用 curl 拉 release(不走 git,所以 git 的 insteadOf 重写无效),
#       本脚本改用公共镜像 gh-proxy.com 下载,并把产物放进 Mason 的标准布局,
#       这样 nvim 里 `command = "codelldb"`(依赖 mason/bin 前置到内部 PATH)能直接命中。
#
# 用法:
#   bash install-codelldb.sh                 # 默认版本 + 默认镜像
#   CODELLDB_VERSION=v1.12.2 bash install-codelldb.sh
#   MIRROR=https://ghproxy.net bash install-codelldb.sh
#
# 注意:请用平时运行 nvim 的那个用户来执行(装进该用户的 ~/.local/share/nvim/mason)。

set -euo pipefail

# ---- 可配置项 -------------------------------------------------------------
CODELLDB_VERSION="${CODELLDB_VERSION:-v1.12.2}"
# 候选镜像(按顺序尝试,最后一个是直连兜底)。实测 gh-proxy.com 约 1MB/s。
MIRRORS=(
  "${MIRROR:-https://gh-proxy.com}"
  "https://ghproxy.net"
  ""   # 空串 = 直连 github.com(兜底,可能很慢)
)
MASON_ROOT="${MASON_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/nvim/mason}"
# --------------------------------------------------------------------------

PKG_DIR="$MASON_ROOT/packages/codelldb"
BIN_DIR="$MASON_ROOT/bin"
BIN_WRAPPER="$BIN_DIR/codelldb"

# ---- 选择架构对应的 vsix --------------------------------------------------
case "$(uname -m)" in
  x86_64|amd64)  VSIX="codelldb-linux-x64.vsix" ;;
  aarch64|arm64) VSIX="codelldb-linux-arm64.vsix" ;;
  *) echo "不支持的架构: $(uname -m)" >&2; exit 1 ;;
esac

REL_PATH="vadimcn/vscode-lldb/releases/download/${CODELLDB_VERSION}/${VSIX}"
TMP_VSIX="$(mktemp -t codelldb.XXXXXX.vsix)"
trap 'rm -f "$TMP_VSIX"' EXIT

# ---- 下载(逐个镜像尝试,直到拿到一个合法 zip)---------------------------
download_ok=0
for m in "${MIRRORS[@]}"; do
  if [ -n "$m" ]; then
    url="${m%/}/https://github.com/${REL_PATH}"
  else
    url="https://github.com/${REL_PATH}"
  fi
  echo ">>> 尝试下载: $url"
  if curl -fL --connect-timeout 15 --max-time 900 \
        -o "$TMP_VSIX" \
        -w "    code=%{http_code} size=%{size_download} speed=%{speed_download}B/s time=%{time_total}s\n" \
        "$url"; then
    # .vsix 本质是 zip,校验一下别把错误页面当成包
    if unzip -tqq "$TMP_VSIX" >/dev/null 2>&1; then
      echo ">>> 下载成功且校验通过。"
      download_ok=1
      break
    else
      echo "    下载到的文件不是合法 zip,换下一个镜像。" >&2
    fi
  else
    echo "    该镜像失败,换下一个。" >&2
  fi
done

if [ "$download_ok" -ne 1 ]; then
  echo "所有镜像都失败了。" >&2
  exit 1
fi

# ---- 解压并安装到 Mason 布局 ---------------------------------------------
echo ">>> 安装到: $PKG_DIR"
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR"
# vsix 内的 extension/ 就是 mason 期望的目录结构
unzip -q "$TMP_VSIX" "extension/*" -d "$PKG_DIR"

ADAPTER="$PKG_DIR/extension/adapter/codelldb"
if [ ! -f "$ADAPTER" ]; then
  echo "解压后没找到 adapter 二进制: $ADAPTER" >&2
  exit 1
fi
chmod +x "$ADAPTER"
# 顺带给内置 lldb 的可执行文件加执行权限(通常已有,保险起见)
find "$PKG_DIR/extension/lldb/bin" -type f -exec chmod +x {} + 2>/dev/null || true

# ---- 生成 Mason 的 bin 包装脚本 ------------------------------------------
# codelldb 的 adapter 通过 rpath($ORIGIN/../lldb/lib)自己找 liblldb,无需额外 env。
mkdir -p "$BIN_DIR"
cat > "$BIN_WRAPPER" <<EOF
#!/usr/bin/env bash
exec "$ADAPTER" "\$@"
EOF
chmod +x "$BIN_WRAPPER"

# ---- 验证 ----------------------------------------------------------------
echo ">>> 验证:"
if "$BIN_WRAPPER" --version 2>/dev/null; then
  :
else
  # 某些版本 --version 返回非零但仍打印,直接再跑一次看输出
  "$BIN_WRAPPER" --version || echo "    (--version 返回非零,但二进制已就位,dap 启动时通常仍可用)"
fi

echo
echo "完成 ✅"
echo "  二进制 : $ADAPTER"
echo "  包装脚本: $BIN_WRAPPER"
echo
echo "下一步:重启 nvim(mason 会把 $BIN_DIR 前置到内部 PATH),"
echo "然后用 <F5> / <leader>d 启动调试即可。"
