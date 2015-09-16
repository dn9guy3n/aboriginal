#!/bin/bash

# Download all the source tarballs we haven't got up-to-date copies of.

# The tarballs are downloaded into the "packages" directory, which is
# created as needed.

source sources/include.sh || exit 1

mkdir -p "$SRCDIR" || dienow

echo "=== Download source code."

# Note: set SHA1= blank to skip checksum validation.

# A blank SHA1 value means accept anything, and the download script
# prints out the sha1 of such files after downloading it.  So to update to
# a new version of a file, set SHA1= and update the URL, run ./download.sh,
# then cut and paste the sha1 from the output and run it again to confirm.

# Building a cross compile toolchain requires linux headers, uClibc,
# binutils, and gcc.

URL=http://uclibc.org/downloads/uClibc-0.9.33.2.tar.bz2 \
SHA1=4d8d67d6754409bd10015d67d1ce7a04c0b001ba \
maybe_fork "download || dienow"

URL=http://www.musl-libc.org/releases/musl-1.1.11.tar.gz \
SHA1=28eb54aeb3d2929c1ca415bb7853127e09bdf246 \
maybe_fork "download || dienow"

URL=ftp://kernel.org/pub/linux/kernel/v4.x/linux-4.1.tar.gz \
SHA1=dce24ac1874f362000e40027075e7d24ba123b73 \
maybe_fork "download || dienow"


# 2.17 was the last GPLv2 release of binutils, but git commit
# 397a64b350470350c8e0adb2af84439ea0f89272 was the last GPLv2
# _version_ of binutils. This tarball has prebuilt release files
# so it builds without optional dependencies such as lex and yacc.

URL=http://landley.net/aboriginal/mirror/binutils-397a64b3.tar.bz2 \
SHA1=f74f1ce2e62c516ba832f99a94289930be7869cf \
maybe_fork "download || dienow"

# elf2flt needed for nommu targets which can't mmap() the elf segments.
# From git://git.sourceforge.jp/gitroot/uclinux-h8/elf2flt.git branch h8300

URL=http://landley.net/aboriginal/mirror/elf2flt-332e3d67e763.tar.gz \
SHA1=23279cdd550f557cef8e83e0e0f3e33d04b1d1bd \
maybe_fork "download || dienow"

# 4.2.1 was the last GPLv2 release of gcc

URL=ftp://ftp.gnu.org/gnu/gcc/gcc-4.2.1/gcc-core-4.2.1.tar.bz2 \
SHA1=43a138779e053a864bd16dfabcd3ffff04103213 \
maybe_fork "download || dienow"

# The g++ version must match gcc version.

URL=http://ftp.gnu.org/gnu/gcc/gcc-4.2.1/gcc-g++-4.2.1.tar.bz2 \
SHA1=8f3785bd0e092f563e14ecd26921cd04275496a6 \
maybe_fork "download || dienow"

# Building a native root filesystem requires linux and uClibc (above) plus
# BusyBox.  Adding a native toolchain requires binutils and gcc (above) plus
# make and bash.

URL=http://landley.net/toybox/downloads/toybox-0.6.0.tar.gz \
SHA1=08fb1c23f520c25a15f262a8a95ea5b676a98d54 \
maybe_fork "download || dienow"

URL=http://www.busybox.net/downloads/busybox-1.22.1.tar.bz2 \
SHA1=d6e96fefb6f0fb8079f27468b9bf22d8dd96108e \
maybe_fork "download || dienow"

URL=ftp://ftp.gnu.org/gnu/make/make-3.81.tar.bz2 \
SHA1=41ed86d941b9c8025aee45db56c0283169dcab3d \
maybe_fork "download || dienow"

# This version of bash is ancient, but it provides everything most package
# builds need and is less than half the size of current versions.  Eventually,
# either busybox ash or toysh should grow enough features to replace bash.

URL=http://ftp.gnu.org/gnu/bash/bash-2.05b.tar.gz \
SHA1=b3e158877f94e66ec1c8ef604e994851ee388b09 \
maybe_fork "download || dienow"

# These are optional parts of the native root filesystem.

URL=http://cxx.uclibc.org/src/uClibc++-0.2.2.tar.bz2 \
SHA1=f5582d206378d7daee6f46609c80204c1ad5c0f7 \
maybe_fork "download || dienow"

URL=http://distcc.googlecode.com/files/distcc-3.1.tar.bz2 \
SHA1=30663e8ff94f13c0553fbfb928adba91814e1b3a \
maybe_fork "download || dienow"

# The following packages are built and run on the host only.  (host-tools.sh
# also builds host versions of many packages in the native root filesystem,
# but the following packages are not cross compiled for the target, and thus
# do not wind up in the system image.)

URL=http://downloads.sf.net/genext2fs/genext2fs-1.4.1.tar.gz &&
SHA1=9ace486ee1bad0a49b02194515e42573036f7392 \
maybe_fork "download || dienow"

URL=https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.13/e2fsprogs-1.42.13.tar.gz \
SHA1=5205e5e55ca6602fc273a03123262e96405b430c \
maybe_fork "download || dienow"

URL=http://zlib.net/zlib-1.2.7.tar.bz2 \
SHA1=858818fe6d358ec682d54ac5e106a2dd62628e7f \
maybe_fork "download || dienow"

URL=http://downloads.sf.net/squashfs/squashfs4.2.tar.gz \
SHA1=e0944471ff68e215d3fecd464f30ea6ceb635fd7 \
RENAME="s/(squashfs)(.*)/\1-\2/" \
maybe_fork "download || dienow"

rm -f "$SRCDIR"/MANIFEST  # So cleanup_oldfiles doesn't warn about it.
cleanup_oldfiles

echo === Got all source.

# Create a MANIFEST file listing package versions.

# This can optionally call source control systems (git, hg and svn) to get
# version information for the packages and build scripts.  These
# are intentionally excluded from the new path setup by host-tools.sh, so
# just in case we've already run that use $OLDPATH for this.

PATH="$OLDPATH" do_manifest > "$SRCDIR"/MANIFEST || dienow
