#!/bin/bash

ver=26.3.2-0

export PATH="/home/lixq/toolchains/Miniforge3-$ver/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LDFLAGS="-static-libgcc -static-libstdc++"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3-$ver/lib/pkgconfig"

rm -rf /root/.pip
mkdir /root/.pip
cat > /root/.pip/pip.conf << EOF
[global]
index-url = https://repo.haplat.net/api/pypi/pypi-all/simple
EOF
rm -rf /root/.condarc
cat > /root/.condarc << EOF
show_channel_urls: true
default_channels:
  - https://repo.haplat.net/anaconda/pkgs/main
  - https://repo.haplat.net/anaconda/pkgs/r
  - https://repo.haplat.net/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://repo.haplat.net/anaconda/cloud
  msys2: https://repo.haplat.net/anaconda/cloud
  bioconda: https://repo.haplat.net/anaconda/cloud
  menpo: https://repo.haplat.net/anaconda/cloud
  pytorch: https://repo.haplat.net/anaconda/cloud
  simpleitk: https://repo.haplat.net/anaconda/cloud
report_errors: false
EOF
[[ -f /home/lixq/src/Miniforge3-$ver-Linux-x86_64.sh ]] || exit 1
rm -rf /home/lixq/toolchains/Miniforge3-$ver

# Miniforge3-26.3.2-0-Linux-x86_64.sh 无法正常离线安装
# bash /home/lixq/src/Miniforge3-$ver-Linux-x86_64.sh -b -p /home/lixq/toolchains/Miniforge3-$ver || exit 1
# 先解压（会因断网在 Transaction 阶段失败，但 pkgs/ 和 explicit.txt 已生成）
unshare --net bash /home/lixq/src/Miniforge3-$ver-Linux-x86_64.sh -b -p /home/lixq/toolchains/Miniforge3-$ver || true
# 把 explicit.txt 里硬编码的 conda.anaconda.org 替换成内网镜像
EXPLICIT=/home/lixq/toolchains/Miniforge3-$ver/conda-meta/initial-state.explicit.txt
[[ -f "$EXPLICIT" ]] || { echo "ERROR: explicit.txt not found, extraction failed"; exit 1; }
sed -i 's|https://conda.anaconda.org/conda-forge|https://repo.haplat.net/anaconda/cloud/conda-forge|g' "$EXPLICIT"
# 用内嵌的 micromamba 离线安装
PREFIX=/home/lixq/toolchains/Miniforge3-$ver
CONDA_SAFETY_CHECKS=disabled \
CONDA_EXTRA_SAFETY_CHECKS=no \
CONDA_CHANNELS="conda-forge" \
CONDA_PKGS_DIRS="$PREFIX/pkgs" \
"$PREFIX/_conda" install --offline --file "$EXPLICIT" -yp "$PREFIX" --no-rc || exit 1

cd /home/lixq/toolchains || exit 1
rm -rf Miniforge3
ln -s Miniforge3-$ver Miniforge3
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install ipython invoke neovim h11 pytz cryptography h2 hpack hyperframe json5 robotframework six websockets pytest pyparsing scapy pytest-timeout pytest-html python-jenkins markdown atlassian-python-api paramiko pycryptodome chardet requests requests_toolbelt atlassian urllib3 meson flask ipython invoke neovim h11 pytz cryptography h2 hpack hyperframe json5 robotframework six websockets pytest pyparsing scapy pytest-timeout pytest-html python-jenkins markdown atlassian-python-api paramiko pycryptodome chardet requests requests_toolbelt beautifulsoup4 atlassian urllib3 bs4 meson flask markdown PyYAML playwright atlassian-python-api lxml
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install cython
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install pandas

echo /home/lixq/shark-test/lib > /home/lixq/toolchains/Miniforge3/lib/python3.13/site-packages/shark-test.pth
echo /home/lixq/shark-test/lib/archive >> /home/lixq/toolchains/Miniforge3/lib/python3.13/site-packages/shark-test.pth