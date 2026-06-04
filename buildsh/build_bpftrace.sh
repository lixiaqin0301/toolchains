#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.26.1
DESTDIR=$1
srcpath=/home/lixq/src/$name-binary_tools_man-bundle-$ver.tar.xz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
df | grep "$DESTDIR" && exit 1

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[[ -d $DESTDIR/usr ]] || mkdir -p "$DESTDIR/usr"
cd "$DESTDIR/usr" || exit 1
tar -xf "$srcpath" || exit 1
cd "$DESTDIR" || exit 1
"$DESTDIR/usr/bin/bpftrace" --appimage-extract
rm -rf "$DESTDIR/usr/bin/bpftrace"
{
    echo "#!/bin/bash"
    echo "'$DESTDIR/squashfs-root/AppRun' \"\$@\""
    echo "for _ in {1..100}; do"
    echo "    df | grep '$DESTDIR/squashfs-root/mountroot' || continue"
    echo "    umount '$DESTDIR/squashfs-root/mountroot'"
    echo "done"
} > "$DESTDIR/usr/bin/bpftrace"
chmod 755 "$DESTDIR/usr/bin/bpftrace"
