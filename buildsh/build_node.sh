#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=v25.9.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/Miniforge3/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPPFLAGS="-I$DESTDIR/include --sysroot=$DESTDIR"
export LDFLAGS=" -L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
export LIBRARY_PATH="$DESTDIR/usr/lib64:$DESTDIR/lib64"

[[ -d $DESTDIR/usr/lib64 ]] || mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64" || exit 1
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1

while IFS= read -r f; do
    $f --help 2>&1 | grep -q GLIBC || continue
    [[ -f "$f.real" ]] || mv "$f" "$f.real"
    rm -f "$f"
    {
        echo "#!/bin/bash"
        echo "exec '$DESTDIR/lib64/ld-linux-x86-64.so.2' --library-path '$DESTDIR/lib64:$DESTDIR/usr/lib64' '$f.real' \"\$@\""
    } > "$f"
    chmod 755 "$f"
done < <(find "$DESTDIR" -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)

"$DESTDIR/usr/bin/npm" config set registry https://repo.haplat.net/npm/ || exit 1
"$DESTDIR/usr/bin/npm" update -g
"$DESTDIR/usr/bin/npm" install -g @anthropic-ai/claude-code || exit 1
"$DESTDIR/usr/bin/npm" install -g @openai/codex@latest || exit 1
"$DESTDIR/usr/bin/npm" install -g opencode-ai@latest || exit 1
"$DESTDIR/usr/bin/npm" install -g markdownlint-cli2 || exit 1
"$DESTDIR/usr/bin/npm" install -g prettier || exit 1

while IFS= read -r f; do
    $f --help 2>&1 | grep -q GLIBC || continue
    [[ -f "$f.real" ]] || mv "$f" "$f.real"
    rm -f "$f"
    {
        echo "#!/bin/bash"
        echo "exec '$DESTDIR/lib64/ld-linux-x86-64.so.2' --library-path '$DESTDIR/lib64:$DESTDIR/usr/lib64' '$f.real' \"\$@\""
    } > "$f"
    chmod 755 "$f"
done < <(find "$DESTDIR" -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)
