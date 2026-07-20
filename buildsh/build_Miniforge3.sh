#!/bin/bash

ver=26.3.2-3

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

bash /home/lixq/src/Miniforge3-$ver-Linux-x86_64.sh -b -p /home/lixq/toolchains/Miniforge3-$ver || exit 1

cd /home/lixq/toolchains || exit 1
rm -rf Miniforge3
ln -s Miniforge3-$ver Miniforge3
# onnxruntime 1.27.0    https://pypi.org/project/onnxruntime/
/home/lixq/toolchains/Miniforge3/bin/pip3 install /home/lixq/src/onnxruntime-1.27.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_17_x86_64.whl
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install ipython invoke neovim h11 pytz cryptography h2 hpack hyperframe json5 robotframework six websockets pytest pyparsing scapy pytest-timeout pytest-html python-jenkins markdown atlassian-python-api paramiko pycryptodome chardet requests requests_toolbelt atlassian urllib3 meson flask ipython invoke neovim h11 pytz cryptography h2 hpack hyperframe json5 robotframework six websockets pytest pyparsing scapy pytest-timeout pytest-html python-jenkins markdown atlassian-python-api paramiko pycryptodome chardet requests requests_toolbelt beautifulsoup4 atlassian urllib3 bs4 meson flask markdown PyYAML playwright atlassian-python-api lxml markitdown pip-review pyright ruff
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install cython
/home/lixq/toolchains/Miniforge3/bin/pip3 --trusted-host repo.haplat.net install pandas

echo /home/lixq/shark-test/lib > /home/lixq/toolchains/Miniforge3/lib/python3.13/site-packages/shark-test.pth
echo /home/lixq/shark-test/lib/archive >> /home/lixq/toolchains/Miniforge3/lib/python3.13/site-packages/shark-test.pth

while IFS= read -r f; do
    $f --help 2>&1 | grep -q GLIBC || continue
    [[ -f "$f.real" ]] || mv "$f" "$f.real"
    rm -f "$f"
    {
        echo "#!/bin/bash"
        echo "exec /opt/glibc/lib/ld-linux-x86-64.so.2 --library-path /opt/glibc/lib:/lib64 '$f.real' \"\$@\""
    } > "$f"
    chmod 755 "$f"
done < <(find /home/lixq/toolchains/Miniforge3-$ver -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)
