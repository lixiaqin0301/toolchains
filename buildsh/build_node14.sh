#!/bin/bash

ver=v14.17.3

export PATH="/home/lixq/toolchains/llvm/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/lixq/toolchains/Bear/usr/bin"
export CC="/home/lixq/toolchains/llvm/usr/bin/clang"
export CXX="/home/lixq/toolchains/llvm/usr/bin/clang++"
export CFLAGS="-g -Wno-error"
export CXXFLAGS="-g -Wno-error -fno-strict-enums --gcc-toolchain=/home/lixq/toolchains/gcc/usr"
export LDFLAGS="-L/home/lixq/toolchains/llvm/usr/lib64 -L/home/lixq/toolchains/gcc/usr/lib64 --gcc-toolchain=/home/lixq/toolchains/gcc/usr -Wl,-rpath-link,/home/lixq/toolchains/llvm/usr/lib64:/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath,/home/lixq/toolchains/llvm/usr/lib64:/home/lixq/toolchains/gcc/usr/lib64"
#export CFLAGS="-g3 -gdwarf-4 -gstrict-dwarf -fno-eliminate-unused-debug-types -fno-eliminate-unused-debug-symbols -fvar-tracking-assignments -fno-omit-frame-pointer -O0 $CFLAGS"
#export CXXFLAGS="-g3 -gdwarf-4 -gstrict-dwarf -fno-eliminate-unused-debug-types -fno-eliminate-unused-debug-symbols -fvar-tracking-assignments -fno-omit-frame-pointer -O0 $CXXFLAGS"

if [[ ! -f /home/lixq/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-vscode ]] || mkdir /home/lixq/workspace-vscode
cd /home/lixq/workspace-vscode || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/src/node-${ver}.tar.gz
cd /home/lixq/workspace-vscode/node-${ver} || exit 1
sed -i '/#include <string>/a #include <cstdint>' deps/v8/src/base/logging.h deps/v8/src/inspector/v8-string-conversions.h
sed -i 's/static constexpr T kMax = static_cast<T>(kNumValues - 1);/static constexpr U kMax = kNumValues - 1;/' deps/v8/src/base/bit-field.h
sed -e 's/STATIC_ASSERT(OptimizationMarker::kLastOptimizationMarker/STATIC_ASSERT(static_cast<int>(OptimizationMarker::kLastOptimizationMarker)/' \
    -e 's/STATIC_ASSERT(OptimizationTier::kLastOptimizationTier/STATIC_ASSERT(static_cast<int>(OptimizationTier::kLastOptimizationTier)/' \
    -i deps/v8/src/objects/feedback-vector.h \
sed -e 's/STATIC_ASSERT(BailoutReason::kLastErrorMessage/STATIC_ASSERT(static_cast<int>(BailoutReason::kLastErrorMessage)/' \
    -e 's/STATIC_ASSERT(FunctionSyntaxKind::kLastFunctionSyntaxKind/STATIC_ASSERT(static_cast<int>(FunctionSyntaxKind::kLastFunctionSyntaxKind)/' \
    -i deps/v8/src/objects/shared-function-info.h
sed -i 's/STATIC_ASSERT(\([a-zA-Z0-9:]*\)::\([a-zA-Z0-9]*\) <= \(.*\)::kMax);/STATIC_ASSERT(static_cast<int>(\1::\2) <= \3::kMax);/' deps/v8/src/objects/js-*.h
sed -i 's/DCHECK_\([GL]\)E(\(.*\), \(.*\))/DCHECK_\1E(static_cast<unsigned int>(\2), static_cast<unsigned int>(\3))/' deps/v8/src/objects/*.h
sed -i 's/DCHECK(script_offset <= ScriptOffsetField::kMax - 2);/DCHECK(script_offset <= static_cast<int>(ScriptOffsetField::kMax) - 2);/' deps/v8/src/codegen/source-position.h
sed -i 's/DCHECK(inlining_id <= InliningIdField::kMax - 2);/DCHECK(inlining_id <= static_cast<int>(InliningIdField::kMax) - 2);/' deps/v8/src/codegen/source-position.h
sed -i '/#include <memory>/i #include <cstdint>' src/inspector/worker_inspector.h
./configure --prefix=/home/lixq/toolchains/node14-${ver} --shared --debug --debug-node --debug-lib --gdb --v8-non-optimized-debug --v8-with-dchecks --v8-enable-object-print || exit 1
bear -- make || exit 1
rm -rf /home/lixq/toolchains/node14-${ver}
make install || exit 1
cd /home/lixq/toolchains/node14-${ver}/lib || exit 1
ln -s libnode.so.* libnode.so
cp /home/lixq/workspace-vscode/node-${ver}/deps/v8/include/v8-inspector*.h /home/lixq/toolchains/node14-${ver}/include/node/
