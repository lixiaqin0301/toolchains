#!/bin/bash

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

if [[ ! -f /home/lixq/toolchains/src/vim-8.2.tar.bz2 ]]; then
    if ! wget http://mirrors.ustc.edu.cn/vim/unix/vim-8.2.tar.bz2 -O /home/lixq/toolchains/src/vim-8.2.tar.bz2; then
        rm -f /home/lixq/toolchains/src/vim-8.2.tar.bz2*
        echo "Need /home/lixq/toolchains/src/vim-8.2.tar.bz2 (http://mirrors.ustc.edu.cn/vim/unix/vim-8.2.tar.bz2)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf vim82
tar -xvf vim-8.2.tar.bz2
cd /home/lixq/toolchains/src/vim82 || exit 1
rm -rf /home/lixq/toolchains/vim-8.2
./configure --prefix=/home/lixq/toolchains/vim-8.2 || exit 1
./configure --prefix=/home/lixq/toolchains/vim-8.2 --enable-luainterp=yes --enable-mzschemeinterp --enable-perlinterp=yes --enable-pythoninterp=yes --enable-python3interp=yes --enable-tclinterp=yes --enable-rubyinterp=yes --enable-cscope --enable-terminal --enable-autoservername --enable-multibyte || exit 1

make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/vim-8.2 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm vim
    ln -s vim-8.2 vim
fi
