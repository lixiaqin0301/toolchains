#!/bin/bash

ver=15.2.0

gmp='gmp-6.2.1.tar.bz2'
mpfr='mpfr-4.1.0.tar.bz2'
mpc='mpc-1.2.1.tar.gz'
isl='isl-0.24.tar.bz2'
gettext='gettext-0.22.tar.gz'

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

cd /home/lixq/35share-rd/src || exit 1
need_exit=no
if [[ ! -f gcc-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/gcc-${ver}/gcc-${ver}.tar.gz -O gcc-${ver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f ${gmp} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gmp/${gmp} -O ${gmp}"
    need_exit=yes
fi
if [[ ! -f ${mpfr} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/mpfr/${mpfr} -O ${mpfr}"
    need_exit=yes
fi
if [[ ! -f ${mpc} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/mpc/${mpc} -O ${mpc}"
    need_exit=yes
fi
if [[ ! -f ${isl} ]]; then
    echo "wget https://gcc.gnu.org/pub/gcc/infrastructure/${isl} -O ${isl}"
    need_exit=yes
fi
if [[ ! -f ${gettext} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gettext/${gettext} -O ${gettext}"
    need_exit=yes
fi
if [[ "$need_exit" == "yes" ]]; then
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf gcc-${ver}
tar -xf /home/lixq/35share-rd/src/gcc-${ver}.tar.gz
cd /home/lixq/src/gcc-${ver} || exit 1
cp /home/lixq/35share-rd/src/${gmp} .
cp /home/lixq/35share-rd/src/${mpfr} .
cp /home/lixq/35share-rd/src/${mpc} .
cp /home/lixq/35share-rd/src/${isl} .
cp /home/lixq/35share-rd/src/${gettext} .
./contrib/download_prerequisites
mkdir -p /home/lixq/src/gcc-${ver}/build
cd /home/lixq/src/gcc-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/gcc-${ver} --disable-multilib || exit 1
make -j"$(nproc)"
cd /home/lixq/src/gcc-${ver}/build/x86_64-pc-linux-gnu/libsanitizer/asan || exit 1
/bin/sh ../libtool --tag=CC   --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DASAN_HAS_EXCEPTIONS=1 -DASAN_NEEDS_SEGV=1 -DCAN_SANITIZE_UB=0 -DASAN_HAS_CXA_RETHROW_PRIMARY_EXCEPTION=0 -DHAVE_AS_SYM_ASSIGN=1  -I. -I../../../../libsanitizer/asan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT asan_interceptors_vfork.lo -MD -MP -MF .deps/asan_interceptors_vfork.Tpo -c -o asan_interceptors_vfork.lo ../../../../libsanitizer/asan/asan_interceptors_vfork.S
cd /home/lixq/src/gcc-${ver}/build/x86_64-pc-linux-gnu/libsanitizer/tsan || exit 1
/bin/sh ../libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -I. -I../../../../libsanitizer/tsan -I..  -I ../../../../libsanitizer -I ../../../../libsanitizer/include  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT tsan_rtl_amd64.lo -MD -MP -MF .deps/tsan_rtl_amd64.Tpo -c -o tsan_rtl_amd64.lo ../../../../libsanitizer/tsan/tsan_rtl_amd64.S
cd /home/lixq/src/gcc-${ver}/build/x86_64-pc-linux-gnu/libsanitizer/hwasan || exit 1
/bin/sh ../libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT hwasan_interceptors_vfork.lo -MD -MP -MF .deps/hwasan_interceptors_vfork.Tpo -c -o hwasan_interceptors_vfork.lo ../../../../libsanitizer/hwasan/hwasan_interceptors_vfork.S
/bin/sh ../libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT hwasan_setjmp_aarch64.lo -MD -MP -MF .deps/hwasan_setjmp_aarch64.Tpo -c -o hwasan_setjmp_aarch64.lo ../../../../libsanitizer/hwasan/hwasan_setjmp_aarch64.S
/bin/sh ../libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT hwasan_setjmp_x86_64.lo -MD -MP -MF .deps/hwasan_setjmp_x86_64.Tpo -c -o hwasan_setjmp_x86_64.lo ../../../../libsanitizer/hwasan/hwasan_setjmp_x86_64.S
/bin/sh ../libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT hwasan_tag_mismatch_aarch64.lo -MD -MP -MF .deps/hwasan_tag_mismatch_aarch64.Tpo -c -o hwasan_tag_mismatch_aarch64.lo ../../../../libsanitizer/hwasan/hwasan_tag_mismatch_aarch64.S
cd /home/lixq/src/gcc-${ver}/build/x86_64-pc-linux-gnu/libitm || exit 1
/bin/sh ./libtool --tag=CC --mode=compile /home/lixq/toolchains/gcc/bin/gcc -DHAVE_CONFIG_H -I. -I../../../libitm  -I../../../libitm/config/linux/x86 -I../../../libitm/config/linux -I../../../libitm/config/x86 -I../../../libitm/config/posix -I../../../libitm/config/generic -I../../../libitm  -mrtm -Wall -Werror  -Wc,-pthread -fcf-protection -mshstk -g -O2 -I/home/lixq/toolchains/gcc/include -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/libtool/include -MT sjlj.lo -MD -MP -MF .deps/sjlj.Tpo -c -o sjlj.lo ../../../libitm/config/x86/sjlj.S
cd /home/lixq/src/gcc-${ver}/build || exit 1
make -j"$(nproc)" || exit 1
rm -rf /home/lixq/toolchains/gcc-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/gcc-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gcc
    ln -s gcc-${ver} gcc
fi
