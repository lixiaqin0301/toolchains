#!/bin/bash

ver=8.2

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

if [[ ! -f /home/lixq/src/vim-${ver}.tar.bz2 ]]; then
    if ! wget http://mirrors.ustc.edu.cn/vim/unix/vim-${ver}.tar.bz2 -O /home/lixq/src/vim-${ver}.tar.bz2; then
        rm -f /home/lixq/src/vim-${ver}.tar.bz2*
        echo "Need /home/lixq/src/vim-${ver}.tar.bz2 (http://mirrors.ustc.edu.cn/vim/unix/vim-${ver}.tar.bz2)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf vim82
tar -xvf vim-${ver}.tar.bz2
cd /home/lixq/src/vim82 || exit 1
rm -rf /home/lixq/toolchains/vim-${ver}
#./configure --prefix=/home/lixq/toolchains/vim-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/vim-${ver} --enable-luainterp=yes --enable-mzschemeinterp --enable-perlinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-tclinterp=yes --enable-rubyinterp=yes --enable-cscope --enable-terminal --enable-autoservername --enable-multibyte || exit 1

make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/vim-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm vim
    ln -s vim-${ver} vim
fi
