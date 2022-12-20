#!/bin/bash

trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Set the timezone
ln -sf /usr/share/zoneinfo/"${TZ:?}" /etc/localtime || exit 1

# Set real-time (hardware) clock to UTC
# TODO: Not working in chroot currently
# timedatectl set-local-rtc 0 || exit 1

# Set the real-time (hardware) clock using the system time
hwclock --systohc || exit 1

# Enable NTP
# TODO: Not working in chroot currently
# timedatectl set-ntp 1 || exit 1


exit 0
