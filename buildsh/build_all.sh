#!/bin/bash
set -euo pipefail
# eclipse              2026-06         https://www.eclipse.org/downloads/packages/
#                                      https://mirrors.aliyun.com/eclipse/technology/epp/downloads/release/
#                                      markdown json(Wild Web Developer) bash
# cygwin               3.6.9           https://cygwin.com/
# rime                 0.17.4          https://rime.im/
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
npm update -g
npm update -g --prefix=/usr/local
/home/lixq/toolchains/data/update-claude.sh
/home/lixq/toolchains/data/reset-claude.sh
/home/lixq/toolchains/data/lazyvim/update-lazyvim.sh
firefox_ver=$(curl -fsSL --max-time 15 https://product-details.mozilla.org/1.0/firefox_versions.json | jq -r .LATEST_FIREFOX_VERSION)
firefox_cver=$(sed -n 's/^Version=//p' "/mnt/d/Programs/Mozilla Firefox/application.ini")
if [[ "$firefox_ver" != "$firefox_cver" ]]; then
    echo "FireFox 需要更新 https://www.firefox.com/en-US/download/all/desktop-release/win64/zh-CN/"
fi

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

rime_frost_ver=$(git ls-remote --tags --refs https://github.com/gaboolic/rime-frost.git | awk -F '/' '{print $NF}' | sed 's/^v//' | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ "$rime_frost_ver" != 1.0.4 ]]; then
    echo "Nerd Fonts 需要更新 https://github.com/gaboolic/rime-frost/releases"
fi
pydev_ver=$(git ls-remote --tags --refs https://github.com/fabioz/Pydev.git | awk -F '/' '{print $NF}' | sed -e 's/^pydev_//' -e "s/_/./g" | grep -oE '^[0-9]+\.([0-9]+\.*)*' | sort -V | tail -1)
if [[ "$pydev_ver" != 13.1.0 ]]; then
    echo "PyDev 需要更新 https://github.com/fabioz/Pydev/releases"
fi
