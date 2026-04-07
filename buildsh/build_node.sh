#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=v22.22.2
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

# node 22 的 npm 有问题
if [[ -d "$DESTDIR/usr/lib/node_modules/npm/node_modules/promise-retry" && ! -d "$DESTDIR/usr/lib/node_modules/promise-retry" ]]; then
    cp -r "$DESTDIR/usr/lib/node_modules/npm/node_modules/promise-retry" "$DESTDIR/usr/lib/node_modules/"
    "$DESTDIR/usr/bin/npm" update -g || exit 1
    rm -rf "$DESTDIR/usr/lib/node_modules/promise-retry"
fi
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

cat > "$DESTDIR/usr/bin/fake_patchelf.sh" << EOF
#!/bin/bash
rm -rf /usr/local/bin/node
ln -s '$DESTDIR/usr/bin/node' /usr/local/bin/node
for f in claude codex corepack markdownlint-cli2 npm npx opencode pnpm pnpx prettier yarn yarnpkg; do
    [[ -L "$DESTDIR/usr/bin/\$f" ]] || continue
    rm -rf "/usr/local/bin/\$f"
    ln -s "\$(realpath "$DESTDIR/usr/bin/\$f")" "/usr/local/bin/\$f"
done
for arg in "\$@"; do
    [[ "\$arg" == */node ]] || continue
    [[ -f "\$arg" ]] || continue
    [[ -L "\$arg" ]] && continue
    mv "\$arg" "\${arg}.real"
    ln -s '$DESTDIR/usr/bin/node' "\$arg"
done
EOF
chmod 755 "$DESTDIR/usr/bin/fake_patchelf.sh"
cat > "$DESTDIR/usr/bin/adjust_cpptools_claude.sh" << EOF
#!/bin/bash
for f in ~/.vscode-server/extensions/anthropic.claude-code-*/resources/native-binary/claude \\
         ~/.local/share/code-server/extensions/anthropic.claude-code-*/resources/native-binary/claude; do
    if "\$f" --help 2>&1 | grep -q GLIBC; then
        mv "\$f" "\$f".real
        ln -s "\$(realpath '$DESTDIR/usr/bin/claude')" "\$f"
    fi
done
for d in ~/.vscode-server/extensions/ms-vscode.cpptools-*/debugAdapters/bin/ \\
         ~/.local/share/code-server/extensions/ms-vscode.cpptools-*/debugAdapters/bin/; do
    if "\$d/OpenDebugAD7" --help 2>&1 | grep GLIBCXX; then
        cd "\$d" || continue
        rm -rf netcoredeps
        mkdir netcoredeps
        cd netcoredeps || continue
        for p in '$DESTDIR'/usr/lib64/libstdc++.s*[0-9o]; do
            [[ -f \$(basename "\$p") ]] && continue
            if [[ -L \$p ]]; then
                ln -sf "\$(readlink "\$p")" "\$(basename "\$p")"
            else
                cp "\$p" .
            fi
        done
    fi
done
EOF
chmod 755 "$DESTDIR/usr/bin/adjust_cpptools_claude.sh"
