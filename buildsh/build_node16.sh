#!/bin/bash

ver=v16.20.2

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
. /opt/rh/devtoolset-11/enable
export PATH="$PATH:/home/lixq/toolchains/Bear/usr/bin"
export CFLAGS="-g3 -gdwarf-4 -gstrict-dwarf -fno-eliminate-unused-debug-types -fno-eliminate-unused-debug-symbols -fvar-tracking-assignments -fno-omit-frame-pointer -O0 $CFLAGS"
export CXXFLAGS="-g3 -gdwarf-4 -gstrict-dwarf -fno-eliminate-unused-debug-types -fno-eliminate-unused-debug-symbols -fvar-tracking-assignments -fno-omit-frame-pointer -O0 $CXXFLAGS"

if [[ ! -f /home/lixq/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-vscode ]] || mkdir /home/lixq/workspace-vscode
cd /home/lixq/workspace-vscode || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/src/node-${ver}.tar.gz
cd /home/lixq/workspace-vscode/node-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/node16-${ver} --shared --debug --debug-node --debug-lib --gdb --v8-non-optimized-debug --v8-with-dchecks --v8-enable-object-print || exit 1
bear -- make || exit 1
rm -rf /home/lixq/toolchains/node16-${ver}
make install || exit 1
cd /home/lixq/toolchains/node16-${ver}/lib || exit 1
ln -s libnode.so.* libnode.so
cp /home/lixq/workspace-vscode/node-${ver}/deps/v8/include/v8-inspector*.h /home/lixq/toolchains/node16-${ver}/include/node/
