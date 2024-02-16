#!/bin/sh

# Disable Kernel Messages
dmesg -n 1

# Mount the file system
mount -t devtmpfs none /dev
mount -t proc none /dev
mount -t sysfs none /sys

# Start shell
/bin/sh

# Shutdown the machine when shell is exited
poweroff -f