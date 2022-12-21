#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Configure and generate the initramfs
sed -i "s/^HOOKS=.*/HOOKS=(base udev autodetect modconf block keyboard zfs filesystems)/" /etc/mkinitcpio.conf || exit 1
zgenhostid "$(hostid)" || exit 1
mkinitcpio -P || exit 1

exit 0
