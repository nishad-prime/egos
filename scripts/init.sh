#!/bin/sh

# Disable Kernel Messages
dmesg -n 1

# Mount the file system
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

clear

# Print the welcome message
echo "Welcome to the Linux Kernel"
echo ""
echo ""
echo "  ___       ___  ___ ";
echo " | __|__ _ / _ \/ __|";
echo " | _|/ _\` | (_) \__ \\";
echo " |___\__, |\___/|___/";
echo "     |___/           ";
echo "Is Built Successfully!";
echo ""
echo ""
echo "Kernel Version: $(uname -r)"
echo "Kernel Build Date: $(uname -v)"
echo "Kernel Architecture: $(uname -m)"
echo "Kernel Compiler: $(uname -o)"
echo "Kernel Hostname: $(uname -n)"


# Start shell with proper tty and power off support
exec cttyhack sh