#!/bin/bash
set -euo pipefail

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
npm update -g
npm update -g --prefix=/usr/local
/home/lixq/toolchains/data/update-claude.sh
rm -rf /usr/local/bin/claude
ln -s /root/.local/share/claude/versions/* /usr/local/bin/claude
/home/lixq/toolchains/data/reset-claude.sh
/home/lixq/toolchains/data/lazyvim/update-lazyvim.sh

chrome_appid=$(/mnt/c/Windows/System32/reg.exe query "HKLM\SOFTWARE\WOW6432Node\Google\Update\Clients" /s /f 'Google Chrome' /d | tr -d '\r' | grep -B1 'REG_SZ *Google Chrome$' | sed -n 's/.*Clients\\\({.*}\)$/\1/p')
chrome_cur=$(/mnt/c/Windows/System32/reg.exe query "HKLM\SOFTWARE\WOW6432Node\Google\Update\Clients\\$chrome_appid" /v pv | tr -d '\r' | awk '/REG_SZ/{print $NF; exit}')
rm -rf /tmp/chrome
curl -o /tmp/chrome -fsSL --max-time 20 -X POST -H 'Content-Type: text/xml' --data-binary @- "https://tools.google.com/service/update2" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<request protocol="3.0" version="chrome-1.0" prodversion="1.0" updaterchannel="stable" upverter="1.0">
  <os platform="win" version="10.0" arch="x64"/>
  <app appid="$chrome_appid" version="$chrome_cur" ap="stable" installsource="ondemand">
    <updatecheck/>
  </app>
</request>
EOF
if ! grep -q 'updatecheck status="noupdate"' /tmp/chrome; then
    echo "Chrome 需要更新 https://www.google.cn/chrome/?standalone=1&platform=win64"
fi

tabby_ver=$(git ls-remote --tags --refs https://github.com/Eugeny/tabby.git | awk -F '/' '{print $NF}' | sed 's/^v//' | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ ! -d "/mnt/d/Programs/tabby-$tabby_ver-portable-x64/" ]]; then
    echo "tabby 需要更新 https://github.com/Eugeny/tabby/releases"
fi

nerd_fonts_ver=$(git ls-remote --tags --refs https://github.com/ryanoasis/nerd-fonts.git | awk -F '/' '{print $NF}' | sed 's/^v//' | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ "$nerd_fonts_ver" != 3.5.1 ]]; then
    echo "Nerd Fonts 需要更新 https://github.com/ryanoasis/nerd-fonts/releases"
fi

rime_ver=$(git ls-remote --tags --refs https://github.com/rime/weasel.git | awk -F '/' '{print $NF}' | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ "$rime_ver" != 0.17.4 ]]; then
    echo "rime 需要更新 https://rime.im/"
fi
rime_frost_ver=$(git ls-remote --tags --refs https://github.com/gaboolic/rime-frost.git | awk -F '/' '{print $NF}' | sed 's/^v//' | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ "$rime_frost_ver" != 1.0.4 ]]; then
    echo "Nerd Fonts 需要更新 https://github.com/gaboolic/rime-frost/releases"
fi

cygwin_ver=$(curl -fsSL --max-time 20 https://cygwin.com/ | tr '\n' ' ' | grep -oiP 'most recent version of the Cygwin DLL is\s*<b>\s*(<a[^>]*>)?\K[0-9]+\.[0-9.]+')
if [[ "$cygwin_ver" != 3.6.10 ]]; then
    echo "cygwin 需要更新 https://cygwin.com/ curl wget nginx ngx-mod_stream vim rsync python inetutils"
fi

if [[ $(curl -so/dev/null -w '%{http_code}\n' "https://update.code.visualstudio.com/api/update/win32-x64-user/stable/$(jq -r .commit "/mnt/d/Programs/Microsoft VS Code"/*/resources/app/product.json)") != 204 ]]; then
    echo "VSCode 需要更新"
fi

firefox_ver=$(curl -fsSL --max-time 15 https://product-details.mozilla.org/1.0/firefox_versions.json | jq -r .LATEST_FIREFOX_VERSION)
firefox_cver=$(sed -n 's/^Version=//p' "/mnt/d/Programs/Mozilla Firefox/application.ini")
if [[ "$firefox_ver" != "$firefox_cver" ]]; then
    echo "FireFox 需要更新 https://www.firefox.com/en-US/download/all/desktop-release/win64/zh-CN/"
fi
