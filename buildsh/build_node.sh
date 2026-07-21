#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=v26.5.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/Miniforge3/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPPFLAGS="-I$DESTDIR/include --sysroot=$DESTDIR"
export LDFLAGS=" -L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
export LIBRARY_PATH="$DESTDIR/usr/lib64:$DESTDIR/lib64"

mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64"
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./configure "--prefix=$DESTDIR/usr" --shared
make -s "-j$(nproc)"
make -s "-j$(nproc)" install

while IFS= read -r f; do
    $f --help 2>&1 | grep -q GLIBC || continue
    [[ -f "$f.real" ]] || mv "$f" "$f.real"
    rm -f "$f"
    {
        echo "#!/bin/bash"
        echo "exec '$DESTDIR/lib64/ld-linux-x86-64.so.2' --library-path '$DESTDIR/lib64:$DESTDIR/usr/lib64:/lib64:/lib' --argv0 '$f' '$f.real' \"\$@\""
    } > "$f"
    chmod 755 "$f"
done < <(find "$DESTDIR" -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)

cd "$DESTDIR/usr/lib"
[[ -f libnode.so ]] || ln -s libnode.so.[1-9]* libnode.so

"$DESTDIR/usr/bin/npm" config set registry https://repo.haplat.net/npm/
"$DESTDIR/usr/bin/npm" update -g --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g markdownlint-cli2 --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g prettier --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g typescript --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g typescript-language-server --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g @vtsls/language-server --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g bash-language-server --allow-remote=all
"$DESTDIR/usr/bin/npm" install -g markdown-toc --allow-remote=all

while IFS= read -r f; do
    $f --help 2>&1 | grep -q GLIBC || continue
    [[ -f "$f.real" ]] || mv "$f" "$f.real"
    rm -f "$f"
    {
        echo "#!/bin/bash"
        echo "exec '$DESTDIR/lib64/ld-linux-x86-64.so.2' --library-path '$DESTDIR/lib64:$DESTDIR/usr/lib64:/lib64:/lib' --argv0 '$f' '$f.real' \"\$@\""
    } > "$f"
    chmod 755 "$f"
done < <(find "$DESTDIR" -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)
