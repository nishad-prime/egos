#!/bin/sh

set -e

# Disable Kernel Messages
dmesg -n 1
clear

# Mount the file system
mount -t devtmpfs udev /dev
mount -t proc proc /proc
mount -t sysfs sysfs /sys

# Start shell with proper tty and power off support
exec cttyhack sh -c '\
clear\
echo "Welcome to the Linux Kernel"\
echo ""\
echo ""\
echo "  ___       ___  ___ "\
echo " | __|__ _ / _ \/ __|"\
echo " | _|/ _\` | (_) \__ \\"\
echo " |___\__, |\___/|___/"\
echo "     |___/           "\
echo "Less is more easy.  -  EgOS"\
echo ""\
echo ""\
echo "Kernel Version: $(uname -r)"\
echo "Kernel Build Date: $(uname -v)"\
echo "Kernel Architecture: $(uname -m)"\
echo "Kernel Compiler: $(uname -o)"\
'