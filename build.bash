#!/bin/bash

. config.bash

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
    git\
    grub-common

# Create the directory structure
mkdir -p iso/boot/grub
mkdir -p initramfs/{bin,sbin,etc,proc,sys,usr/{bin,sbin}}

# Download the kernel source
wget https://www.kernel.org/pub/linux/kernel/v${LINUX_MAJOR}.x/linux-${LINUX_VERSION}.tar.xz
tar -xf linux-${LINUX_VERSION}.tar.xz
cd linux-${LINUX_VERSION}
    make -j$(nproc) x86_64_defconfig
    cp ../config/linux.config .config
    make -j$(nproc) bzImage
    echo $PWD
    cp arch/x86/boot/bzImage ../iso/boot/.
cd ..

# Download the busybox source
wget https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
tar -xf busybox-${BUSYBOX_VERSION}.tar.bz2
cd busybox-${BUSYBOX_VERSION}
    cp ../config/busybox.config .config
    make -j$(nproc)
    make CONFIG_PREFIX=../initramfs install
cd ..

# Create the initramfs
sudo mount -t proc /proc initramfs/proc
sudo mount -t sysfs /sys initramfs/sys
sudo mount -o bind /dev initramfs/dev
sudo mount -o bind /dev/pts initramfs/dev/pts
cd initramfs
    find . | cpio -H newc -o > ../iso/boot/initramfs.cpio

# Install GRUB
cp config/grub.cfg iso/boot/grub/grub.cfg

# Create the bootable image
grub-mkrescue -o egos.iso iso

# The image is ready to be used
echo "  ___       ___  ___ ";
echo " | __|__ _ / _ \/ __|";
echo " | _|/ _\` | (_) \__ \\";
echo " |___\__, |\___/|___/";
echo "     |___/           ";
echo "Is Built Successfully!";