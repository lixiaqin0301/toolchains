#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=15.2.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
gmp='gmp-6.2.1.tar.bz2'
mpfr='mpfr-4.1.0.tar.bz2'
mpc='mpc-1.2.1.tar.gz'
isl='isl-0.24.tar.bz2'
gettext='gettext-0.22.tar.gz'

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/$gmp     ]] || exit 1
[[ -f /home/lixq/src/$mpfr    ]] || exit 1
[[ -f /home/lixq/src/$mpc     ]] || exit 1
[[ -f /home/lixq/src/$isl     ]] || exit 1
[[ -f /home/lixq/src/$gettext ]] || exit 1

if [[ $DESTDIR == /opt/gcc ]]; then
    export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export LDFLAGS="-L/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath-link,/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath,/opt/gcc/usr/lib64"
else
    export PATH="/opt/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export LDFLAGS="-L/opt/gcc/usr/lib64 -Wl,-rpath-link,/opt/gcc/usr/lib64 -Wl,-rpath,/home/lixq/toolchains/gcc/usr/lib64"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
cp /home/lixq/src/$gmp . || exit 1
cp /home/lixq/src/$mpfr . || exit 1
cp /home/lixq/src/$mpc . || exit 1
cp /home/lixq/src/$isl . || exit 1
cp /home/lixq/src/$gettext . || exit 1
./contrib/download_prerequisites
mkdir build
cd build || exit 1
../configure --prefix="$DESTDIR/usr" --disable-multilib --enable-ld || exit 1
if ! make -k -s -j"$(nproc)"; then
    if [[ -d /home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/asan ]]; then
        cd "/home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/asan" || exit 1
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DASAN_HAS_EXCEPTIONS=1 -DASAN_NEEDS_SEGV=1 -DCAN_SANITIZE_UB=0 -DASAN_HAS_CXA_RETHROW_PRIMARY_EXCEPTION=0 -DHAVE_AS_SYM_ASSIGN=1  -I. -I../../../../libsanitizer/asan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -MT asan_interceptors_vfork.lo -MD -MP -MF .deps/asan_interceptors_vfork.Tpo -c -o asan_interceptors_vfork.lo ../../../../libsanitizer/asan/asan_interceptors_vfork.S
    fi
    if [[ -d /home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/tsan ]]; then
        cd "/home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/tsan" || exit 1
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -I. -I../../../../libsanitizer/tsan -I..  -I ../../../../libsanitizer -I ../../../../libsanitizer/include  -fcf-protection -mshstk -g -O2 -MT tsan_rtl_amd64.lo -MD -MP -MF .deps/tsan_rtl_amd64.Tpo -c -o tsan_rtl_amd64.lo ../../../../libsanitizer/tsan/tsan_rtl_amd64.S
    fi
    if [[ -d /home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/hwasan ]]; then
        cd "/home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libsanitizer/hwasan" || exit 1
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -MT hwasan_interceptors_vfork.lo -MD -MP -MF .deps/hwasan_interceptors_vfork.Tpo -c -o hwasan_interceptors_vfork.lo ../../../../libsanitizer/hwasan/hwasan_interceptors_vfork.S
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -MT hwasan_setjmp_aarch64.lo -MD -MP -MF .deps/hwasan_setjmp_aarch64.Tpo -c -o hwasan_setjmp_aarch64.lo ../../../../libsanitizer/hwasan/hwasan_setjmp_aarch64.S
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -MT hwasan_setjmp_x86_64.lo -MD -MP -MF .deps/hwasan_setjmp_x86_64.Tpo -c -o hwasan_setjmp_x86_64.lo ../../../../libsanitizer/hwasan/hwasan_setjmp_x86_64.S
        /bin/sh ../libtool --tag=CC --mode=compile "$CC" -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -DCAN_SANITIZE_UB=0 -DHWASAN_WITH_INTERCEPTORS=1 -I. -I../../../../libsanitizer/hwasan -I..  -I ../../../../libsanitizer/include -I ../../../../libsanitizer  -fcf-protection -mshstk -g -O2 -MT hwasan_tag_mismatch_aarch64.lo -MD -MP -MF .deps/hwasan_tag_mismatch_aarch64.Tpo -c -o hwasan_tag_mismatch_aarch64.lo ../../../../libsanitizer/hwasan/hwasan_tag_mismatch_aarch64.S
    fi
    if [[ -d /home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libitm ]]; then
        cd "/home/lixq/src/$name-$ver/build/x86_64-pc-linux-gnu/libitm" || exit 1
        /bin/sh ./libtool --tag=CC --mode=compile "$CC" -DHAVE_CONFIG_H -I. -I../../../libitm  -I../../../libitm/config/linux/x86 -I../../../libitm/config/linux -I../../../libitm/config/x86 -I../../../libitm/config/posix -I../../../libitm/config/generic -I../../../libitm  -mrtm -Wall -Werror  -Wc,-pthread -fcf-protection -mshstk -g -O2 -MT sjlj.lo -MD -MP -MF .deps/sjlj.Tpo -c -o sjlj.lo ../../../libitm/config/x86/sjlj.S
    fi
fi
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
cd "$DESTDIR/usr/bin" || exit 1
ln -s gcc cc
