#!/bin/bash
# Build the CodeLLDB debug adapter from source, against the locally built
# LLVM/LLDB 22.1.8 (glibc 2.17 compatible). The upstream prebuilt adapter needs
# GLIBC_2.35; this one is native to this host so no patchelf/loader tricks.
#
# We do NOT use CodeLLDB's CMake driver: it also builds the VSCode extension
# (webpack), the debuggee and runs `npm install` at configure time, none of
# which nvim-dap needs. Instead we replicate exactly what adapter/CMakeLists.txt
# feeds to cargo (the toolchain-x86_64-linux-gnu.cmake flags + the adapter
# externalproject build command).
#
# Result layout (matches what src/codelldb/bin/main.rs expects at runtime):
#   $DESTDIR/extension/adapter/codelldb          <- the adapter (this build)
#   $DESTDIR/extension/adapter/codelldb-launch    <- terminal launcher (same dir)
#   $DESTDIR/extension/adapter/scripts/**          <- python scripts (this build)
#   $DESTDIR/extension/lldb/lib/liblldb.so         <- symlink to our liblldb
#   $DESTDIR/extension/lldb/bin/{lldb-server,lldb-argdumper}
# codelldb, given no --liblldb, loads <exe dir>/../lldb/lib/liblldb.so.
set -euo pipefail

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.12.2
DESTDIR=${1:-/home/lixq/toolchains/$name}
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

LLVM=/home/lixq/toolchains/llvm/usr
TRIPLE=x86_64-unknown-linux-gnu
# Uppercased triple for cargo's per-target env vars (X86_64_UNKNOWN_LINUX_GNU).
TRIPLE_ENV=${TRIPLE//-/_}
TRIPLE_ENV=${TRIPLE_ENV^^}

# --- toolchain on PATH: clang/clang++/ld.lld/llvm-strip, cargo, then system ---
export PATH="$LLVM/bin:/root/.cargo/bin:$PATH"

# --- crate/git fetching through the corporate mirror (see ~/.cargo & git config) ---
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# --- how the lldb / lldb-stub build.rs find LLDB headers and the dylib ---
# The install tree's include/ has the full (incl. generated) LLDB C++ API headers.
export LLDB_INCLUDE="$LLVM/include"
export LLDB_DYLIB="$LLVM/lib/liblldb.so"

# --- compilers for the cc / cpp_build crates (mirror the toolchain file) ---
export CC_${TRIPLE_ENV}=clang
export CXX_${TRIPLE_ENV}=clang++
export CFLAGS_${TRIPLE_ENV}=""
# toolchain-x86_64-linux-gnu.cmake sets CMAKE_CXX_FLAGS_INIT=-stdlib=libc++.
# -Wno-invalid-specialization: LLVM 22's libc++ marks std::is_default_constructible
# with [[__no_specializations__]]; the lldb crate deliberately specializes it
# (sbcommandinterpreter.rs) for LLDB<18 compat, which would otherwise be an error.
export CXXFLAGS_${TRIPLE_ENV}="-stdlib=libc++ -Wno-invalid-specialization"
# rustc links the final binaries by invoking clang as the linker driver.
export CARGO_TARGET_${TRIPLE_ENV}_LINKER=clang

# Some build scripts (e.g. lldb-stub's weaklink probe) compile C++ with cc-rs for
# the *host*, which reads the un-suffixed CC/CXX/CXXFLAGS. The system c++ is GCC
# 4.8.5 (no -std=c++17), so point host compilation at clang too.
export CC=clang
export CXX=clang++
export CFLAGS=""
export CXXFLAGS="-stdlib=libc++ -Wno-invalid-specialization"

# Fresh source tree
cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"

# Keep all cargo artifacts inside the source tree's build/ (like cmake would).
export CARGO_TARGET_DIR="$PWD/build/target"

# Linker flags used by adapter/CMakeLists.txt for the codelldb binary on Linux:
#   packed split debuginfo, link via lld, and statically pull in libc++/libc++abi
#   so the adapter carries no libc++.so.1 runtime dependency.
RUSTC_LINK_FLAGS=(
    -Csplit-debuginfo=packed
    -Clink-arg=-fuse-ld=lld
    -Clink-arg=-L"$LLVM/lib/$TRIPLE"
    -Clink-arg=-Wl,-Bstatic,-lc++,-lc++abi,-Bdynamic
)

echo ">>> building codelldb adapter (release, no_link_args / weak liblldb) ..."
cargo rustc --package=codelldb --bin=codelldb \
    --manifest-path="$PWD/Cargo.toml" --target="$TRIPLE" --release \
    --features=no_link_args -- "${RUSTC_LINK_FLAGS[@]}"

echo ">>> building codelldb-launch ..."
cargo build --package=codelldb-launch \
    --manifest-path="$PWD/Cargo.toml" --target="$TRIPLE" --release

OUT="$PWD/build/target/$TRIPLE/release"

# --- install into the extension layout ---
EXT="$DESTDIR/extension"
mkdir -p "$EXT/adapter" "$EXT/bin" "$EXT/lldb/lib" "$EXT/lldb/bin"

install -m755 "$OUT/codelldb"        "$EXT/adapter/codelldb"
# terminal.rs looks for codelldb-launch next to the codelldb exe (adapter/);
# the VSCode packaging also keeps a copy in bin/. Provide both.
install -m755 "$OUT/codelldb-launch" "$EXT/adapter/codelldb-launch"
install -m755 "$OUT/codelldb-launch" "$EXT/bin/codelldb-launch"

# Python adapter scripts shipped with this codelldb version.
rm -rf "$EXT/adapter/scripts"
cp -a adapter/scripts "$EXT/adapter/scripts"
rm -f "$EXT/adapter/scripts/CMakeLists.txt"
# lang_support/*.py (rust value formatters etc.)
mkdir -p "$EXT/lang_support"
cp -a lang_support/*.py "$EXT/lang_support/" 2>/dev/null || true

# liblldb + companion binaries (only create if not already wired up).
[[ -e $EXT/lldb/lib/liblldb.so ]] || ln -sf "$LLVM/lib/liblldb.so" "$EXT/lldb/lib/liblldb.so"
for b in lldb-server lldb-argdumper lldb; do
    [[ -e $EXT/lldb/bin/$b ]] || ln -sf "$LLVM/bin/$b" "$EXT/lldb/bin/$b"
done

echo ">>> strip debug info"
llvm-strip --strip-debug "$EXT/adapter/codelldb" "$EXT/adapter/codelldb-launch" "$EXT/bin/codelldb-launch"

echo ">>> done: $EXT/adapter/codelldb"
