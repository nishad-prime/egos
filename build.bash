#!/bin/bash

. config/config.bash

set -e

# Install the required packages
sudo apt-get update
sudo apt-get install -y\
    curl\
    xz-utils\
    bzip2\
    fakeroot\
    build-essential\
    ncurses-dev\
    libssl-dev\
    bc\
    flex\
    libelf-dev\
    bison\
    autoconf\
    libtool\
    libpng-dev\
    libfreetype-dev\
    git

# Create the dist directory
mkdir -p dist/boot

# Download the kernel source
wget https://www.kernel.org/pub/linux/kernel/v${LINUX_MAJOR}.x/linux-${LINUX_MAJOR}.${LINUX_MINOR}.${LINUX_PATCH}.tar.xz
tar -xf linux-${LINUX_MAJOR}.${LINUX_MINOR}.${LINUX_PATCH}.tar.xz
cd linux-${LINUX_MAJOR}.${LINUX_MINOR}.${LINUX_PATCH}
    cp ../config/linux.config .config
    make -j$(nproc)
    echo $PWD
    cp arch/x86/boot/bzImage ../dist/boot/.
cd ..

# Download the busybox source
wget https://busybox.net/downloads/busybox-${BUSYBOX_MAJOR}.${BUSYBOX_MINOR}.${BUSYBOX_PATCH}.tar.bz2
tar -xf busybox-${BUSYBOX_MAJOR}.${BUSYBOX_MINOR}.${BUSYBOX_PATCH}.tar.bz2
cd busybox-${BUSYBOX_MAJOR}.${BUSYBOX_MINOR}.${BUSYBOX_PATCH}
    cp ../config/busybox.config .config
    make -j$(nproc)
    make CONFIG_PREFIX=../dist install
cd ..

# Create the bootable image
dd if=/dev/zero of=dist/boot/boot.img bs=1M count=256
mkfs.ext4 dist/boot/boot.img
mkdir -p dist/mnt
sudo mount dist/boot/boot.img dist/mnt
    set +e
    sudo cp -r dist/* dist/mnt/.
    set -e
    sudo umount dist/mnt
sudo rmdir dist/mnt
